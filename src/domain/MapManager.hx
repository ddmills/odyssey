package domain;

import common.struct.IntPoint;
import core.Game;
import data.BiomeType;
import data.Cardinal;
import domain.components.Explored;
import domain.components.IsInventoried;
import domain.components.IsPlayer;
import domain.components.Move;
import domain.components.Visible;
import domain.events.ConsumeEnergyEvent;
import domain.terrain.Cell;
import domain.terrain.ChunkManager;
import domain.terrain.ZoneManager;
import domain.terrain.gen.portals.PortalManager;
import domain.terrain.gen.realms.RealmManager;
import ecs.Entity;
import h2d.Bitmap;

class MapManager
{
	public var portals(default, null):PortalManager;
	public var realms(default, null):RealmManager;
	public var zones(default, null):ZoneManager;
	public var chunks(default, null):ChunkManager;

	var visible:Array<IntPoint>;

	public function new()
	{
		portals = new PortalManager();
		realms = new RealmManager();
		zones = new ZoneManager();
		chunks = new ChunkManager();
	}

	public function initialize()
	{
		visible = [];

		portals.initialize();
		realms.initialize();
		zones.initialize();
		chunks.initialize();
	}

	public function getCurrentBiomeType():BiomeType
	{
		var pos = Game.instance.world.player.pos.toIntPoint();
		var data = getMapDataStore();
		return data.getBiomeType(pos);
	}

	private inline function getMapDataStore():MapDataStore
	{
		return realms.hasActiveRealm ? realms : chunks;
	}

	//
	// ENTER/LEAVE REALMS
	//

	public function goToPortal(portalId:String):Bool
	{
		var user = Game.instance.world.player.entity;

		trace('detach player...');
		user.isDetachable = true;
		user.detach();

		var portal = portals.get(portalId);

		if (portal.isNull())
		{
			return false;
		}

		if (portal.position.realmId.hasValue())
		{
			realms.setActiveRealm(portal.position.realmId, portal.id, user);
			reattachEntityAt(user, portal.position.pos);
			return true;
		}

		realms.leaveActiveRealm();

		var destChunks = zones.getChunksForZone(portal.position.zoneId);

		for (c in destChunks)
		{
			chunks.loadChunk(c.chunkId);
		}

		reattachEntityAt(user, portal.position.pos);

		return true;
	}

	public function teleportTo(entity:Entity, worldPos:IntPoint)
	{
		realms.leaveActiveRealm();
		reattachEntityAt(entity, worldPos);
	}

	private function reattachEntityAt(entity:Entity, worldPos:IntPoint)
	{
		entity.reattach();
		entity.remove(Move);
		entity.drawable.pos = null;
		entity.pos = worldPos.asWorld();
		entity.fireEvent(new ConsumeEnergyEvent(1));

		if (entity.has(IsPlayer))
		{
			Game.instance.camera.focus = entity.pos;
		}
	}

	//
	// ENTITIES
	//

	public function updateEntityPosition(entity:Entity, targetWorldPos:IntPoint)
	{
		// TODO: PARENT/CHILD update all child entities as well
		var data = getMapDataStore();
		data.updateEntityPosition(entity, targetWorldPos);
		entity.internalSetPos(targetWorldPos.x, targetWorldPos.y);
	}

	public function getEntitiesAt(worldPos:IntPoint):Array<Entity>
	{
		var data = getMapDataStore();
		var ids = data.getEntityIdsAt(worldPos);

		return ids.map((id:String) -> Game.instance.registry.getEntity(id));
	}

	public function getEntitiesInRect(worldPos:IntPoint, width:Int, height:Int):Array<Entity>
	{
		// TODO: this method is SLOW
		var entities:Array<Entity> = [];

		for (x in worldPos.x...(worldPos.x + width))
		{
			for (y in worldPos.y...(worldPos.y + height))
			{
				entities = entities.concat(getEntitiesAt(new IntPoint(x, y)));
			}
		}

		return entities;
	}

	public function getEntitiesInRange(worldPos:IntPoint, range:Int):Array<Entity>
	{
		var diameter = (range * 2) + 1;
		var topLeft = worldPos.sub(new IntPoint(range, range));
		return getEntitiesInRect(topLeft, diameter, diameter);
	}

	public function getNeighborEntities(pos:IntPoint):Array<Array<Entity>>
	{
		// todo - just make faster by removing cardinal calls?
		return [
			getEntitiesAt(pos.add(Cardinal.NORTH_WEST.toOffset())), // NORTH_WEST
			getEntitiesAt(pos.add(Cardinal.NORTH.toOffset())), // NORTH
			getEntitiesAt(pos.add(Cardinal.NORTH_EAST.toOffset())), // NORTH_EAST
			getEntitiesAt(pos.add(Cardinal.WEST.toOffset())), // WEST
			getEntitiesAt(pos.add(Cardinal.EAST.toOffset())), // EAST
			getEntitiesAt(pos.add(Cardinal.SOUTH_WEST.toOffset())), // SOUTH_WEST
			getEntitiesAt(pos.add(Cardinal.SOUTH.toOffset())), // SOUTH
			getEntitiesAt(pos.add(Cardinal.SOUTH_EAST.toOffset())), // SOUTH_EAST
		];
	}

	//
	// VISION & EXPLORATION
	//

	public function reapplyVisible()
	{
		for (pos in visible)
		{
			setVisible(pos);
		}
	}

	public function clearVisible()
	{
		var data = getMapDataStore();

		for (worldPos in visible)
		{
			data.setExplore(worldPos, true, false);

			// TODO: is this necessary here?
			for (entity in getEntitiesAt(worldPos))
			{
				if (entity.has(Visible) && !entity.has(IsInventoried))
				{
					entity.remove(Visible);
				}
			}
		}
		visible = [];
	}

	public function setVisible(worldPos:IntPoint)
	{
		var data = getMapDataStore();

		data.setVisible(worldPos);

		var light = Game.instance.world.systems.lights.getTileLight(worldPos);

		for (entity in getEntitiesAt(worldPos))
		{
			if (!entity.has(Visible))
			{
				entity.add(new Visible());
			}
			if (!entity.has(Explored))
			{
				entity.add(new Explored());
			}
			if (light.intensity > 0 && entity.drawable != null)
			{
				entity.drawable.shader.isLit = 1;
				entity.drawable.shader.lightColor = light.color.toHxdColor().toVector();
				entity.drawable.shader.lightIntensity = light.intensity;
			}
		}

		visible.push(worldPos);
	}

	public function isExplored(worldPos:IntPoint)
	{
		var data = getMapDataStore();
		return data.isExplored(worldPos);
	}

	public function isVisible(worldPos:IntPoint)
	{
		return visible.exists((v) -> v.equals(worldPos));
	}

	public function getCell(worldPos:IntPoint):Cell
	{
		var data = getMapDataStore();
		return data.getCell(worldPos);
	}

	public function getBackgroundBitmap(worldPos:IntPoint):Bitmap
	{
		var data = getMapDataStore();
		return data.getBackgroundBitmap(worldPos);
	}
}
