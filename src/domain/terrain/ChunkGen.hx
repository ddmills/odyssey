package domain.terrain;

import common.struct.Coordinate;
import common.struct.WeightedTable;
import core.Game;
import data.SpawnableType;
import domain.components.Energy;
import domain.prefabs.Spawner;
import hxd.Rand;

class ChunkGen
{
	private var seed(get, null):Int;

	var table:WeightedTable<SpawnableType>;

	public function new()
	{
		table = new WeightedTable();
		table.add(SNAKE, 15);
		table.add(STICK, 3);
		table.add(CHEST, 3);
		table.add(LOCKBOX, 1);
		table.add(SNUB_NOSE_REVOLVER, 1);
		table.add(REVOLVER, 1);
		table.add(NAVY_REVOLVER, 1);
		table.add(RIFLE, 4);
		table.add(PONCHO, 1);
		table.add(DUSTER, 2);
		table.add(LONG_JOHNS, 3);
		table.add(COACH_GUN, 3);
		table.add(THUG, 8);
		table.add(THUG_2, 8);
		// table.add(CACTUS, 124);
	}

	public function generate(chunk:Chunk)
	{
		var r = new Rand(seed + chunk.chunkId);
		for (i in chunk.exploration)
		{
			var pos = chunk.worldPos.add(i.pos).asWorld();

			if (r.bool(.008))
			{
				var loot = table.pick(r);
				Spawner.Spawn(loot, pos);
			}
		}
	}

	function get_seed():Int
	{
		return Game.instance.world.seed;
	}
}
