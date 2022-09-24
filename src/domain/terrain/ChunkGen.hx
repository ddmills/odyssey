package domain.terrain;

import common.struct.WeightedTable;
import core.Game;
import data.SpawnableType;
import domain.prefabs.Spawner;
import hxd.Rand;

class ChunkGen
{
	private var seed(get, null):Int;

	var table:WeightedTable<SpawnableType>;

	public function new()
	{
		table = new WeightedTable();
		table.add(WAGON_WHEEL, 3);
		table.add(CAMPFIRE, 5);
		table.add(LANTERN, 4);
		table.add(SNAKE, 6);
		table.add(STICK, 3);
		table.add(CHEST, 3);
		table.add(LOCKBOX, 1);
		table.add(SNUB_NOSE_REVOLVER, 1);
		table.add(REVOLVER, 1);
		table.add(NAVY_REVOLVER, 1);
		table.add(RIFLE_AMMO, 2);
		table.add(PISTOL_AMMO, 2);
		table.add(SHOTGUN_AMMO, 2);
		table.add(VIAL, 2);
		table.add(RIFLE, 4);
		table.add(PONCHO, 1);
		table.add(DUSTER, 2);
		table.add(LONG_JOHNS, 3);
		table.add(COACH_GUN, 3);
		table.add(THUG, 4);
		table.add(THUG_2, 4);
		table.add(TOMBSTONE, 4);
		table.add(BOOTS, 4);
		table.add(PANTS, 4);
		table.add(COWBOY_HAT, 4);
	}

	public function generate(chunk:Chunk)
	{
		var r = new Rand(seed + chunk.chunkId);
		for (i in chunk.exploration)
		{
			var pos = chunk.worldPos.add(i.pos);

			if (r.bool(.01))
			{
				var loot = table.pick(r);
				Spawner.Spawn(loot, pos.asWorld());
			}
			else
			{
				var cell = Game.instance.world.map.getCell(pos);
				var b = Game.instance.world.map.getBiome(cell.biomeKey);
				b.spawnEntity(pos, cell);
			}
		}
	}

	inline function get_seed():Int
	{
		return Game.instance.world.seed;
	}
}
