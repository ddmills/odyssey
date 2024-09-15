package domain.terrain;

import common.struct.Grid;
import common.struct.IntPoint;
import common.struct.Set;
import common.tools.Performance;
import core.Game;
import data.BiomeType;
import ecs.Entity;
import h2d.Bitmap;

class ChunkManager implements MapDataStore
{
	private var game(get, never):Game;
	private var chunks:Grid<Chunk>;

	private var chunksToLoad:Set<Int>;
	private var chunksToUnload:Set<Int>;

	public var chunkGen(default, null):ChunkGen;
	public var chunkCountX(get, null):Int;
	public var chunkCountY(get, null):Int;
	public var chunkSize(get, null):Int;

	public function new()
	{
		chunkGen = new ChunkGen();
	}

	public function initialize()
	{
		chunks = new Grid<Chunk>(chunkCountX, chunkCountY);
		chunks.fillFn((idx) -> new Chunk(idx, chunkSize));
		chunksToUnload = new Set();
		chunksToLoad = new Set();
	}

	public function loadChunks(curChunk:Int)
	{
		var curChunkPos = getChunkPos(curChunk);
		var loaded = chunks.filter((item) -> item.value.isLoaded).map((item) -> item.value.chunkId);
		var activeChunkIdxs = new Set<Int>();

		for (x in [-2, -1, 0, 1, 2])
		{
			for (y in [-2, -1, 0, 1, 2])
			{
				var chunkPos = curChunkPos.add(x, y);
				if (chunkPos.x >= 0 || chunkPos.y >= 0 || chunkPos.x < chunkCountX || chunkPos.y < chunkCountY)
				{
					var chunkIdx = getChunkIdx(chunkPos.x, chunkPos.y);
					activeChunkIdxs.add(chunkIdx);
					chunksToUnload.remove(chunkIdx);
				}
			}
		}

		for (chunkIdx in loaded)
		{
			if (!activeChunkIdxs.has(chunkIdx))
			{
				chunksToUnload.add(chunkIdx);
			}
		}

		chunksToLoad = new Set<Int>();

		for (chunkIdx in activeChunkIdxs)
		{
			if (!loaded.contains(chunkIdx))
			{
				chunksToLoad.add(chunkIdx);
			}
		}
	}

	public function unloadAllChunks()
	{
		for (chunk in chunks)
		{
			if (chunk.value.isLoaded)
			{
				saveChunk(chunk.idx, true);
			}
		}

		chunksToLoad = new Set();
		chunksToUnload = new Set();
	}

	public function update()
	{
		var toLoad = chunksToLoad.pop();

		if (toLoad != null)
		{
			var t = Game.instance.frame.getTimeSinceLastFrame();

			if (t > .0005)
			{
				trace('Warning: delaying loading chunk for frame delay');
				return;
			}
		}

		if (toLoad != null)
		{
			loadChunk(toLoad);
		}
		else
		{
			var chunkIdx = chunksToUnload.pop();

			if (chunkIdx != null)
			{
				saveChunk(chunkIdx, true);
			}
		}
	}

	public function save(unload:Bool = false)
	{
		var loaded = chunks.filter((item) -> item.value.isLoaded).map((item) -> item.value.chunkId);
		for (chunkIdx in loaded)
		{
			saveChunk(chunkIdx, unload);
		}
	}

	public function saveChunk(chunkIdx:Int, unload:Bool = false)
	{
		var chunk = getChunkById(chunkIdx);
		Performance.start('chunk-save');
		var data = chunk.save();
		Performance.stop('chunk-save');
		game.files.saveChunk(data);
		if (unload)
		{
			chunk.unload();
		}
	}

	public function loadChunk(chunkIdx:Int)
	{
		var chunk = getChunkById(chunkIdx);
		var data = game.files.tryReadChunk(chunkIdx);
		if (data != null)
		{
			Performance.start('chunk-load');
			chunk.load(data);
			Performance.stop('chunk-load');
		}
		else
		{
			Performance.start('chunk-gen');
			chunk.load();
			Performance.stop('chunk-gen');
		}
	}

	public inline function getChunkIdx(cx:Float, cy:Float):Int
	{
		return chunks.idx(cx.floor(), cy.floor());
	}

	public inline function getChunkIdxByWorld(wx:Float, wy:Float):Int
	{
		return getChunkIdx(Math.floor(wx / chunkSize), Math.floor(wy / chunkSize));
	}

	public inline function getChunkPos(idx:Int):IntPoint
	{
		return chunks.coord(idx);
	}

	public inline function getChunkById(chunkIdx:Int):Chunk
	{
		return chunks.getAt(chunkIdx);
	}

	public overload extern inline function getChunk(cx:Float, cy:Float):Chunk
	{
		return getChunk(cx.floor(), cy.floor());
	}

	public overload extern inline function getChunk(cx:Int, cy:Int):Chunk
	{
		return chunks.get(cx, cy);
	}

	public function isOutOfBounds(pos:IntPoint):Bool
	{
		return chunks.isOutOfBounds(pos.x, pos.y);
	}

	inline function get_chunkCountX():Int
	{
		return game.world.chunkCountX;
	}

	inline function get_chunkCountY():Int
	{
		return game.world.chunkCountY;
	}

	inline function get_chunkSize():Int
	{
		return game.world.chunkSize;
	}

	inline function get_game():Game
	{
		return Game.instance;
	}

	public function getEntityIdsAt(worldPos:IntPoint):Array<String>
	{
		var chunkIdx = getChunkIdxByWorld(worldPos.x, worldPos.y);
		var chunk = getChunkById(chunkIdx);

		if (chunk.isNull())
		{
			return [];
		}

		var localX = worldPos.x % Game.instance.world.chunkSize;
		var localY = worldPos.y % Game.instance.world.chunkSize;

		return chunk.getEntityIdsAt(localX, localY);
	}

	public function getBiomeType(worldPos:IntPoint):BiomeType
	{
		var chunkIdx = getChunkIdxByWorld(worldPos.x, worldPos.y);
		var chunk = getChunkById(chunkIdx);
		return chunk.zone.primaryBiome;
	}

	public function setVisible(worldPos:IntPoint)
	{
		setExplore(worldPos, true, true);
	}

	public function setExplore(worldPos:IntPoint, isExplored:Bool, isVisible:Bool)
	{
		var c = worldToChunk(worldPos);
		var chunk = getChunk(c.x, c.y);

		if (chunk != null)
		{
			var local = worldToChunkLocal(worldPos);

			chunk.setExplore(local, isExplored, isVisible);
		}
	}

	public function isExplored(worldPos:IntPoint):Bool
	{
		var c = worldToChunk(worldPos);
		var chunk = getChunk(c.x, c.y);

		if (chunk.isNull() || !chunk.isLoaded)
		{
			return false;
		}

		var local = worldToChunkLocal(worldPos);
		return chunk.isExplored(local);
	}

	public function getCell(worldPos:IntPoint):Cell
	{
		var c = worldToChunk(worldPos);
		var chunk = getChunk(c.x, c.y);

		if (chunk.isNull())
		{
			return null;
		}

		var local = worldToChunkLocal(worldPos);

		return chunk.getCell(local.x, local.y);
	}

	public inline function worldToChunk(worldPos:IntPoint):IntPoint
	{
		return new IntPoint((worldPos.x / chunkSize).floor(), (worldPos.y / chunkSize).floor());
	}

	public inline function worldToChunkLocal(worldPos:IntPoint):IntPoint
	{
		return new IntPoint(worldPos.x % chunkSize, worldPos.y % chunkSize);
	}

	public function updateEntityPosition(entity:Entity, targetWorldPos:IntPoint)
	{
		// TODO: PARENT/CHILD update all child entities as well
		var previousPos = entity.pos.toIntPoint();
		var previousChunkIdx = getChunkIdxByWorld(previousPos.x, previousPos.y);
		var nextChunkIdx = getChunkIdxByWorld(targetWorldPos.x, targetWorldPos.y);
		var nextChunk = getChunkById(nextChunkIdx);

		if (previousChunkIdx != nextChunkIdx)
		{
			var previousChunk = getChunkById(previousChunkIdx);

			if (previousChunk != null)
			{
				previousChunk.removeEntity(entity);
			}
		}

		var localPos = worldToChunkLocal(targetWorldPos);

		nextChunk.updateEntityPosition(entity, localPos);
	}

	public function getBackgroundBitmap(worldPos:IntPoint):Bitmap
	{
		var c = worldToChunk(worldPos);
		var chunk = getChunk(c.x, c.y);

		if (chunk.isNull())
		{
			return null;
		}

		var local = worldToChunkLocal(worldPos);

		return chunk.getBackgroundBitmap(local);
	}

	public function getAmbientLighting():Float
	{
		return Game.instance.world.clock.getDaylight();
	}
}
