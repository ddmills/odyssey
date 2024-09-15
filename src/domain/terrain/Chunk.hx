package domain.terrain;

import common.struct.Grid;
import common.struct.GridMap;
import common.struct.IntPoint;
import common.util.Projection;
import core.Game;
import data.TileResources;
import data.save.SaveChunk;
import domain.components.Moniker;
import ecs.Entity;
import h2d.Bitmap;
import shaders.SpriteShader;

class Chunk
{
	private var tiles:h2d.Object;

	public var exploration(default, null):Grid<Null<Bool>>;
	public var entities(default, null):GridMap<String>;
	public var bitmaps(default, null):Grid<Bitmap>;
	public var isLoaded(default, null):Bool;
	public var cells(default, null):Grid<Cell>;

	public var size(default, null):Int;
	public var chunkId(default, null):Int;
	public var zoneId(get, never):Int;
	public var zone(get, never):Zone;

	public var chunkPos(get, never):IntPoint;
	public var worldPos(get, never):IntPoint;

	public function new(chunkId:Int, size:Int)
	{
		this.chunkId = chunkId;
		this.size = size;
		cells = new Grid(size, size);
	}

	function get_chunkPos():IntPoint
	{
		return Game.instance.world.map.chunks.getChunkPos(chunkId);
	}

	function get_worldPos():IntPoint
	{
		return chunkPos.multiply(size);
	}

	public function load(?save:SaveChunk)
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

		if (save == null)
		{
			exploration.fill(false);
			Game.instance.world.map.chunks.chunkGen.generate(this);
			buildTiles();
		}
		else
		{
			var tickDelta = Game.instance.world.clock.tick - save.tick;

			size = save.size;
			cells.load(save.cells, (c) -> c);
			buildTiles();

			exploration.load(save.explored, (v) -> v);

			for (e in exploration)
			{
				setExplore(e.pos, e.value, false);
			}

			entities.load(save.entities, (edata) ->
			{
				return edata.map((data) ->
				{
					Entity.Load(data, tickDelta);
					return data.id;
				});
			});
		}

		for (detachedId in Game.instance.registry.getDetachedEntities())
		{
			var e = Game.instance.registry.getEntity(detachedId);
			if (e.chunkIdx == chunkId)
			{
				e.reattach();
				var localPos = Game.instance.world.map.chunks.worldToChunkLocal(e.pos.toIntPoint());
				updateEntityPosition(e, localPos);
			}
		}

		Game.instance.render(BACKGROUND, tiles);

		var pix = worldPos.asWorld().toPx();
		tiles.x = pix.x;
		tiles.y = pix.y;
	}

	public function save():SaveChunk
	{
		if (!isLoaded)
		{
			trace('Cannot save an unloaded chunk');
			return null;
		}

		return {
			idx: chunkId,
			size: size,
			tick: Game.instance.world.clock.tick,
			explored: exploration.save((v) -> v),
			cells: cells.save((v) -> v),
			entities: entities.save((v) ->
			{
				return v.filterMap((id) ->
				{
					var e = Game.instance.registry.getEntity(id);
					if (e != null && !e.isDetachable)
					{
						return {
							value: e.save(),
							filter: true,
						};
					}

					return {
						value: null,
						filter: false,
					};
				});
			})
		};
	}

	public function unload()
	{
		if (!isLoaded)
		{
			trace('Cannot unload an already unloaded chunk');
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

	function buildTiles()
	{
		for (t in bitmaps)
		{
			var bm = buildGroundBitmap(t.pos);

			bm.x = t.x * Game.instance.TILE_W;
			bm.y = t.y * Game.instance.TILE_H;

			tiles.addChildAt(bm, t.idx);
			bitmaps.set(t.x, t.y, bm);
		}
	}

	public function getCell(localX:Int, localY:Int):Cell
	{
		if (!isLoaded)
		{
			return null;
		}
		return cells.get(localX, localY);
	}

	public function getBackgroundBitmap(localPos:IntPoint):Bitmap
	{
		if (!isLoaded)
		{
			return null;
		}

		return bitmaps.get(localPos.x, localPos.y);
	}

	public function getZoneLocalOffset():IntPoint
	{
		return worldPos.sub(zone.worldPos);
	}

	public function hasWorldPoint(pos:IntPoint):Bool
	{
		var diff = pos.sub(worldPos);

		return diff.x >= 0 && diff.x < size && diff.y >= 0 && diff.y < size;
	}

	public inline function getCellCoord(idx:Int):IntPoint
	{
		return cells.coord(idx);
	}

	private function buildGroundBitmap(localPos:IntPoint):Bitmap
	{
		var cell = getCell(localPos.x, localPos.y);

		var tileKey = cell.tileKey;
		var primary = cell.primary;
		var secondary = cell.secondary;
		var background = cell.background;

		if (zone.poi != null)
		{
			var tl = worldPos.sub(zone.worldPos);
			var zPos = tl.add(localPos);
			var tile = zone.poi.getTile(zPos);
			if (tile != null)
			{
				if (tile.tileKey != null)
				{
					tileKey = tile.tileKey;
				}
				if (tile.primary != null)
				{
					primary = tile.primary;
				}
				if (tile.secondary != null)
				{
					secondary = tile.secondary;
				}
				if (tile.background != null)
				{
					background = tile.background;
				}
			}
		}

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

	public function removeEntity(entity:Entity)
	{
		if (!isLoaded)
		{
			return;
		}

		// TODO: PARENT/CHILD remove all child entities as well
		entities.remove(entity.id);
	}

	public function updateEntityPosition(entity:Entity, localPos:IntPoint)
	{
		if (!isLoaded)
		{
			// trace('add entity, not loaded', entity.get(Moniker).displayName);
			// TODO: put these somewhere on spawn
			trace('PLACING ENTITY IN UNLOADED CHUNK', entity.id);
			if (entity.has(Moniker))
			{
				trace(entity.get(Moniker).displayName);
			}
			return;
		}

		// TODO:  PARENT/CHILD update children?
		entities.set(localPos.x, localPos.y, entity.id);
	}

	public function getEntityIdsAt(localX:Int, localY:Int):Array<String>
	{
		if (!isLoaded)
		{
			return [];
		}
		return entities.get(localX, localY);
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
			trace('Warning: Loading chunk on demand');
			Game.instance.world.map.chunks.loadChunk(chunkId);
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

	function get_zoneId():Int
	{
		var pos = chunkPos.divide(Game.instance.world.chunksPerZone).floor();
		return Game.instance.world.map.zones.getZoneId(pos);
	}

	inline function get_zone():Zone
	{
		return Game.instance.world.map.zones.getZoneById(zoneId);
	}
}
