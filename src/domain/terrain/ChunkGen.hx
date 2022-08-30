package domain.terrain;

import core.Game;
import domain.components.Energy;
import domain.prefabs.SnakePrefab;
import domain.prefabs.StickPrefab;
import hxd.Rand;

class ChunkGen
{
	private var seed(get, null):Int;

	public function new() {}

	public function generate(chunk:Chunk)
	{
		var r = new Rand(seed + chunk.chunkId);
		for (i in chunk.exploration)
		{
			var x = chunk.wx + i.x;
			var y = chunk.wy + i.y;

			if (r.bool(.005))
			{
				var snake = SnakePrefab.Create();
				snake.x = x;
				snake.y = y;
				snake.get(Energy).consumeEnergy(r.integer(0, 50));
			}

			if (r.bool(.005))
			{
				var stick = StickPrefab.Create();
				stick.x = x;
				stick.y = y;
			}
		}
	}

	function get_seed():Int
	{
		return Game.instance.world.seed;
	}
}
