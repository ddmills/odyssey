package domain.terrain;

import common.struct.Grid;
import common.struct.GridMap;
import common.struct.IntPoint;
import common.util.Colors;
import core.Game;
import data.TileKey;
import data.TileResources;
import data.save.SaveChunk;
import domain.components.Moniker;
import ecs.Entity;
import h2d.Bitmap;
import hxd.Rand;
import shaders.SpriteShader;

class Chunk
{
	var tiles:h2d.Object; // TODO: switch to h2d.SpriteBatch?

	public var exploration(default, null):Grid<Null<Bool>>;
	public var entities(default, null):GridMap<String>;
	public var bitmaps(default, null):Grid<Bitmap>;
	public var isLoaded(default, null):Bool;

	public var size(default, null):Int;
	public var chunkId(default, null):Int;

	public var chunkPos(get, never):IntPoint;
	public var worldPos(get, never):IntPoint;

	var rand:Rand;

	public function new(chunkId:Int, size:Int)
	{
		this.chunkId = chunkId;
		this.size = size;

		exploration = new Grid(size, size);
		entities = new GridMap(size, size);
		bitmaps = new Grid(size, size);
		rand = new Rand(this.chunkId);
		tiles = new h2d.Object();
	}

	function get_chunkPos():IntPoint
	{
		return Game.instance.world.chunks.getChunkPos(chunkId);
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

		buildTiles();

		if (save == null)
		{
			exploration.fill(false);
			trace('GENERATING CHUNK', chunkId);
			Game.instance.world.chunks.chunkGen.generate(this);
		}
		else
		{
			exploration.load(save.explored, (v) -> v);
			for (e in exploration)
			{
				setExplore(e.x, e.y, e.value, false);
			}
			entities.load(save.entities, (edata) ->
			{
				return edata.map((data) ->
				{
					Entity.Load(data);
					return data.id;
				});
			});
		}

		Game.instance.render(GROUND, tiles);

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
			explored: exploration.save((v) -> v),
			entities: entities.save((v) ->
			{
				return v.map((id) ->
				{
					var e = Game.instance.registry.getEntity(id);
					if (e != null)
					{
						return e.save();
					}
					return null;
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
					e.destroy();
				}
			}
		}

		isLoaded = false;
	}

	function buildTiles()
	{
		for (t in bitmaps)
		{
			var p = worldPos.add(t.pos);

			var bm = getGroundBitmap(p.x, p.y);

			bm.x = t.x * Game.instance.TILE_W;
			bm.y = t.y * Game.instance.TILE_H;

			tiles.addChildAt(bm, t.idx);
			bitmaps.set(t.x, t.y, bm);
		}
	}

	function getGroundBitmap(wx:Float, wy:Float):Bitmap
	{
		var bm = new h2d.Bitmap();

		var pos = new IntPoint(wx.floor(), wy.floor());
		var color = Game.instance.world.map.getColor(pos);
		var shader = new SpriteShader(color);
		// var tile = Game.instance.world.map.getTile(pos);

		// var biome = Game.instance.world.map.biomes.get(tile.biomeKey);
		// shader.background = Colors.Mix(color, 0x000000, .9).toHxdColor();

		shader.clearBackground = 0;

		var mapTile = Game.instance.world.map.tiles.get(pos.x, pos.y);

		if (mapTile.bgTileKey != null)
		{
			bm.tile = TileResources.Get(mapTile.bgTileKey);
		}

		bm.addShader(shader);
		bm.visible = false;

		return bm;
	}

	public function removeEntity(entity:Entity)
	{
		entities.remove(entity.id);
	}

	public function setEntityPosition(entity:Entity)
	{
		if (!isLoaded)
		{
			// TODO: put these somewhere on spawn
			// trace('PLACING ENTITY IN UNLOADED CHUNK');
			// if (entity.has(Moniker))
			// {
			// 	trace(entity.get(Moniker).displayName);
			// }
		}
		var local = entity.pos.toChunkLocal().toWorld();
		entities.set(local.x.floor(), local.y.floor(), entity.id);
	}

	public function getEntityIdsAt(x:Float, y:Float):Array<String>
	{
		return entities.get(x.floor(), y.floor());
	}

	public function setExplore(x:Int, y:Int, isExplored:Bool, isVisible:Bool)
	{
		if (!isLoaded)
		{
			Game.instance.world.chunks.load(chunkId);
			return;
		}
		var idx = exploration.idx(x, y);
		if (idx < 0)
		{
			return;
		}

		exploration.setIdx(idx, isExplored);

		var bm = bitmaps.get(x, y);

		if (bm == null)
		{
			return;
		}

		var shader = bm.getShader(SpriteShader);
		shader.isShrouded = 0;

		if (isExplored)
		{
			bm.visible = true;
			if (!isVisible)
			{
				shader.isShrouded = 1;
			}
		}
		else
		{
			shader.isShrouded = 1;
			bm.visible = false;
		}
	}
}
