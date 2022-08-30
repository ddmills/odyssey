package domain.terrain;

import common.struct.Grid;
import common.util.Projection;
import core.Game;

class ChunkManager
{
	var chunks:Grid<Chunk>;

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
		for (i in 0...chunks.size)
		{
			var coord = chunks.coord(i);
			var chunk = new Chunk(i, coord.x, coord.y, chunkSize);

			chunks.setIdx(i, chunk);
		}
	}

	public inline function getChunkIdx(cx:Float, cy:Float)
	{
		return chunks.idx(cx.floor(), cy.floor());
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
		return Game.instance.world.chunkCountX;
	}

	inline function get_chunkCountY():Int
	{
		return Game.instance.world.chunkCountY;
	}

	inline function get_chunkSize():Int
	{
		return Game.instance.world.chunkSize;
	}
}
