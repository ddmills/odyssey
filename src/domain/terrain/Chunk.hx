package domain.terrain;

import common.struct.Grid;
import common.struct.GridMap;
import common.util.Projection;
import core.Game;
import data.TileResources;
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
	public var cx(default, null):Int;
	public var cy(default, null):Int;
	public var wx(get, null):Int;
	public var wy(get, null):Int;

	var rand:Rand;

	public function new(chunkId:Int, chunkX:Int, chunkY:Int, size:Int)
	{
		this.chunkId = chunkId;
		this.size = size;

		cx = chunkX;
		cy = chunkY;
		exploration = new Grid(size, size);
		entities = new GridMap(size, size);
		bitmaps = new Grid(size, size);
		rand = new Rand(this.chunkId);
	}

	public function setExplore(x:Int, y:Int, isExplored:Bool, isVisible:Bool)
	{
		if (!isLoaded)
		{
			load();
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

	public function load()
	{
		if (isLoaded)
		{
			return;
		}

		Game.instance.world.chunks.chunkGen.generate(this);
		exploration.fill(false);

		buildTiles();

		Game.instance.render(GROUND, tiles);

		var pix = Projection.chunkToPx(cx, cy);
		tiles.x = pix.x;
		tiles.y = pix.y;

		isLoaded = true;
	}

	public function unload()
	{
		if (!isLoaded)
		{
			return;
		}

		tiles.remove();
		tiles.removeChildren();
		bitmaps.clear();
		tiles = null;
		isLoaded = false;
	}

	function buildTiles()
	{
		tiles = new h2d.Object();

		for (t in bitmaps)
		{
			var x = wx + t.x;
			var y = wy + t.y;

			var terrain = Game.instance.world.map.getTerrain(x, y);
			var bm = getTerrainBitmap(x, y, terrain);

			bm.x = t.x * Game.instance.TILE_W;
			bm.y = t.y * Game.instance.TILE_H;

			tiles.addChildAt(bm, t.idx);
			bitmaps.set(t.x, t.y, bm);
		}
	}

	function getTerrainBitmap(wx:Float, wy:Float, type:TerrainType):Bitmap
	{
		var grasses = [
			TileResources.GRASS_1,
			TileResources.GRASS_2,
			TileResources.GRASS_3,
			TileResources.GRASS_4,
		];
		var colors = [0x47423a, 0x5f523a, 0x4F502F, 0x57482e, 0x495228];

		var tile = rand.pick(grasses);
		var bm = new h2d.Bitmap(tile);

		bm.addShader(new SpriteShader(rand.pick(colors), rand.pick(colors)));
		bm.visible = false;

		return bm;
	}

	function get_wx():Int
	{
		return cx * size;
	}

	function get_wy():Int
	{
		return cy * size;
	}

	public function removeEntity(entity:Entity)
	{
		entities.remove(entity.id);
	}

	public function setEntityPosition(entity:Entity)
	{
		var local = entity.pos.toChunkLocal(cx, cy).toWorld();
		entities.set(local.x.floor(), local.y.floor(), entity.id);
	}

	public function getEntityIdsAt(x:Float, y:Float):Array<String>
	{
		return entities.get(x.floor(), y.floor());
	}
}
