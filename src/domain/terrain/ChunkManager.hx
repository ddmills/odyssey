package domain.terrain;

import common.struct.Grid;
import common.struct.Set;
import common.tools.Performance;
import common.util.Projection;
import core.Game;

class ChunkManager
{
	private var game(get, never):Game;
	private var chunks:Grid<Chunk>;
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
		chunksToUnload = new Set();

		for (i in 0...chunks.size)
		{
			var chunk = new Chunk(i, chunkSize);

			chunks.setIdx(i, chunk);
		}
	}

	public function loadChunks(curChunk:Int)
	{
		var curChunkPos = getChunkPos(curChunk);
		var loaded = chunks.filter((item) -> item.value.isLoaded).map((item) -> item.value.chunkId);
		var activeChunkIdxs = new Set<Int>();

		for (x in [-1, 0, 1])
		{
			for (y in [-1, 0, 1])
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
	}

	public function update()
	{
		var chunkIdx = chunksToUnload.pop();

		if (chunkIdx != null)
		{
			saveChunk(chunkIdx, true);
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
		trace(Performance.stop('chunk-save'));
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

	public inline function getChunkIdx(cx:Float, cy:Float)
	{
		return chunks.idx(cx.floor(), cy.floor());
	}

	public inline function getChunkPos(idx:Int)
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

	public inline function getChunkByPx(px:Float, py:Float):Chunk
	{
		var coords = Projection.pxToChunk(px, py);

		return getChunk(Math.floor(coords.x), Math.floor(coords.y));
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
}
