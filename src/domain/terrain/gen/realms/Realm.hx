package domain.terrain.gen.realms;

import common.struct.Grid;
import common.struct.GridMap;
import common.struct.IntPoint;
import core.Game;
import data.TileResources;
import domain.components.Moniker;
import domain.terrain.gen.realms.RealmManager.RealmDefinition;
import ecs.Entity;
import h2d.Bitmap;
import shaders.SpriteShader;

class Realm
{
	private var tiles:h2d.Object;

	public var realmId:String;
	public var exploration(default, null):Grid<Null<Bool>>;
	public var entities(default, null):GridMap<String>;
	public var bitmaps(default, null):Grid<Bitmap>;
	public var isLoaded(default, null):Bool;
	public var cells(default, null):Grid<Cell>;

	public var size(default, null):Int;
	public var worldPos(default, null):IntPoint;

	public var definition(default, null):RealmDefinition;

	public function new(realmId:String, size:Int, worldPos:IntPoint, definition:RealmDefinition)
	{
		this.realmId = realmId;
		this.size = size;
		this.worldPos = worldPos;
		this.definition = definition;

		cells = new Grid(size, size);
		isLoaded = false;
	}

	public function load()
	{
		if (isLoaded)
		{
			return;
		}

		isLoaded = true;
		exploration = new Grid(size, size);
		entities = new GridMap(size, size);
		cells = new GridMap(size, size);
		bitmaps = new Grid(size, size);
		tiles = new h2d.Object();

		exploration.fill(false);
		Game.instance.world.realms.generator.generate(this);
		buildTiles();

		Game.instance.render(GROUND, tiles);

		var pix = worldPos.asWorld().toPx();
		tiles.x = pix.x;
		tiles.y = pix.y;
	}

	public function unload()
	{
		trace('UNLOAD REALM $realmId');

		if (!isLoaded)
		{
			trace('Cannot unload an already unloaded realm');
			return;
		}

		tiles.remove();
		tiles.removeChildren();
		bitmaps.clear();

		for (ids in entities)
		{
			for (id in ids.value.copy())
			{
				var e = Game.instance.registry.getEntity(id);
				if (e != null)
				{
					if (e.isDetachable)
					{
						e.detach();
					}
					else
					{
						e.destroy();
					}
				}
			}
		}

		exploration = null;
		entities = null;
		bitmaps = null;
		tiles = null;
		cells = null;

		isLoaded = false;
	}

	public function setEntityPosition(entity:Entity)
	{
		if (!isLoaded)
		{
			// trace('add entity, not loaded', entity.get(Moniker).displayName);
			// TODO: put these somewhere on spawn
			trace('PLACING ENTITY IN UNLOADED REALM', entity.id);

			if (entity.has(Moniker))
			{
				trace(entity.get(Moniker).displayName);
			}

			return;
		}

		var local = worldPositionToRealmLocal(entity.pos.toIntPoint());
		entities.set(local.x, local.y, entity.id);
	}

	public function getEntityIdsAt(world:IntPoint):Array<String>
	{
		if (!isLoaded)
		{
			return [];
		}

		var local = worldPositionToRealmLocal(world);

		return entities.get(local.x, local.y);
	}

	public function isExplored(pos:IntPoint)
	{
		if (!isLoaded)
		{
			return false;
		}

		return exploration.get(pos.x, pos.y);
	}

	public function setExplore(localPos:IntPoint, isExplored:Bool, isVisible:Bool)
	{
		if (!isLoaded)
		{
			trace('ERROR: REALM NOT LOADED');
			return;
		}

		var idx = exploration.idx(localPos.x, localPos.y);
		if (idx < 0)
		{
			return;
		}

		exploration.setIdx(idx, isExplored);

		var bm = bitmaps.get(localPos.x, localPos.y);

		if (bm == null)
		{
			return;
		}

		var shader = bm.getShader(SpriteShader);

		if (isExplored)
		{
			bm.visible = true;
			if (!isVisible)
			{
				shader.setShrouded(true);
			}
			else
			{
				shader.setShrouded(false);
			}
		}
		else
		{
			shader.setShrouded(true);
			bm.visible = false;
		}
	}

	function buildTiles()
	{
		for (t in bitmaps)
		{
			var bm = getGroundBitmap(t.pos);

			bm.x = t.x * Game.instance.TILE_W;
			bm.y = t.y * Game.instance.TILE_H;

			tiles.addChildAt(bm, t.idx);
			bitmaps.set(t.x, t.y, bm);
		}
	}

	public function worldPositionToRealmLocal(pos:IntPoint)
	{
		return pos.sub(worldPos.x, worldPos.y);
	}

	public function getCell(localX:Int, localY:Int):Cell
	{
		if (!isLoaded)
		{
			return null;
		}

		return cells.get(localX, localY);
	}

	private function getGroundBitmap(pos:IntPoint):Bitmap
	{
		var cell = getCell(pos.x, pos.y);

		var tileKey = cell.tileKey;
		var primary = cell.primary;
		var secondary = cell.secondary;
		var background = cell.background;

		var bm = new h2d.Bitmap();
		var shader = new SpriteShader(primary, secondary);

		if (Game.instance.SHOW_BG_COLORS)
		{
			shader.background = background.toHxdColor().toVector();
			shader.clearBackground = 1;
		}

		if (tileKey != null)
		{
			bm.tile = TileResources.Get(tileKey);
		}

		bm.addShader(shader);
		bm.visible = false;

		return bm;
	}
}
