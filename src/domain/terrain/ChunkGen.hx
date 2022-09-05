package domain.terrain;

import common.struct.Coordinate;
import core.Game;
import data.SpawnableType;
import domain.components.Energy;
import domain.prefabs.CactusPrefab;
import domain.prefabs.ChestPrefab;
import domain.prefabs.LockboxPrefab;
import domain.prefabs.SnakePrefab;
import domain.prefabs.Spawner;
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
			var pos = new Coordinate(x, y);

			if (r.bool(.015))
			{
				var snake = Spawner.Spawn(SNAKE, pos);
				snake.get(Energy).consumeEnergy(r.integer(0, 50));
			}
			else if (r.bool(.02))
			{
				var items:Array<SpawnableType> = [CHEST, LOCKBOX, NAVY_REVOLVER, RIFLE, PONCHO, DUSTER, LONG_JOHNS, SNAKE_CORPSE];
				var loot = r.pick(items);
				Spawner.Spawn(loot, pos);
			}
			else if (r.bool(.02))
			{
				Spawner.Spawn(STICK, pos);
			}
			else if (r.bool(.025))
			{
				Spawner.Spawn(CACTUS, pos);
			}
		}
	}

	function get_seed():Int
	{
		return Game.instance.world.seed;
	}
}
