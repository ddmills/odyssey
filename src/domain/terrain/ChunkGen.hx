package domain.terrain;

import core.Game;
import domain.components.Energy;
import domain.prefabs.CactusPrefab;
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

			if (r.bool(.015))
			{
				var snake = SnakePrefab.Create();
				snake.x = x;
				snake.y = y;
				snake.get(Energy).consumeEnergy(r.integer(0, 50));
			}
			else if (r.bool(.045))
			{
				var stick = StickPrefab.Create();
				stick.x = x;
				stick.y = y;
				var stick2 = StickPrefab.Create();
				stick2.x = x;
				stick2.y = y;
			}
			else if (r.bool(.025))
			{
				var cactus = CactusPrefab.Create(r);
				cactus.x = x;
				cactus.y = y;
			}
		}
	}

	function get_seed():Int
	{
		return Game.instance.world.seed;
	}
}
