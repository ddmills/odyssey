package domain;

import common.struct.IntPoint;
import core.Game;
import data.BiomeType;
import data.Cardinal;
import domain.components.Explored;
import domain.components.IsInventoried;
import domain.components.Visible;
import domain.terrain.Cell;
import domain.terrain.ChunkManager;
import domain.terrain.ZoneManager;
import domain.terrain.gen.portals.PortalManager;
import domain.terrain.gen.realms.RealmManager;
import ecs.Entity;

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
	public function usePortal(portalId:String):Bool
	{
		var sourcePortal = portals.get(portalId);

		if (sourcePortal.isNull())
		{
			return false;
		}

		var destinationPortal = portals.get(sourcePortal.destinationId);

		if (destinationPortal.isNull())
		{
			return false;
		}

		return true;
	}

	public function goToOverworldPos(worldPos:IntPoint) {}

	//
	// ENTITIES
	//

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
}
