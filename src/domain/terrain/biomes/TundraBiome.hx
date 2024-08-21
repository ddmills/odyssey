package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKey;
import data.TileKey;
import domain.prefabs.Spawner;

class TundraBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, TUNDRA, C_GRAY, C_GRAY, C_GRAY);
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		if (r.bool(.1))
		{
			cell.tileKey = GRASS_V1_2;
			cell.terrain = TERRAIN_GRASS;
			cell.primary = C_DARK_GRAY;
		}
		else
		{
			var t = r.pick([TERRAIN_BASIC_1, TERRAIN_BASIC_2, TERRAIN_BASIC_3]);
			cell.tileKey = t;
			cell.terrain = TERRAIN_SNOW;
			var c = r.pick([C_GRAY, C_DARK_GREEN, C_DARK_GRAY]);
			cell.primary = c;
		}

		cell.background = C_GRAY;
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_SNOW)
		{
			var trees = perlin.get(pos, 8, 8);
			var berries = perlin.get(pos, 12, 8);
			var rocks = perlin.get(pos, 9, 8);

			if (trees > .6)
			{
				Spawner.Spawn(PINE_TREE, pos.asWorld());
			}
			else if (berries > .8)
			{
				Spawner.Spawn(RASPBERRY_BUSH, pos.asWorld());
			}
			else if (rocks > .7)
			{
				Spawner.Spawn(ROCK, pos.asWorld());
			}
		}
	}
}
