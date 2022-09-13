package domain.terrain;

import common.struct.Coordinate;
import core.Game;
import data.SpawnableType;
import domain.components.Energy;
import domain.prefabs.Spawner;
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
			var pos = chunk.worldPos.add(i.pos).asWorld();

			if (r.bool(.015))
			{
				var items:Array<SpawnableType> = [
					CHEST, LOCKBOX, SNUB_NOSE_REVOLVER, REVOLVER, NAVY_REVOLVER, RIFLE, PONCHO, DUSTER, LONG_JOHNS, COACH_GUN, SNAKE, THUG, THUG_2,
				];
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
