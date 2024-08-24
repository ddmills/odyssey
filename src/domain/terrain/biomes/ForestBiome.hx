package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKey;
import data.TileKey;
import domain.prefabs.Spawner;
import domain.terrain.biomes.Biome.MapIconData;

class ForestBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, FOREST);
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		cell.tileKey = r.pick([GRASS_V1_1, GRASS_V1_2, TERRAIN_BASIC_2, TERRAIN_BASIC_3]);
		cell.terrain = TERRAIN_GRASS;
		var c = r.pick([C_DARK_BROWN, C_DARK_GREEN, C_DARK_GRAY]);
		cell.primary = c;
		cell.background = C_GREEN;
	}

	override function getMapIcon():MapIconData
	{
		return {
			primary: ColorKey.C_DARK_GREEN,
			secondary: ColorKey.C_WOOD,
			background: ColorKey.C_PURPLE,
			tileKey: r.pick([TileKey.OVERWORLD_FOREST_1, TileKey.OVERWORLD_FOREST_2]),
		};
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_GRASS)
		{
			var trees = perlin.get(pos, 8, 8);
			var rocks = perlin.get(pos, 12, 2);
			if (rocks > .67)
			{
				Spawner.Spawn(ROCK, pos.asWorld());
			}
			else if (trees > .55)
			{
				if (r.bool(.25 + trees))
				{
					Spawner.Spawn(PINE_TREE, pos.asWorld());
				}
			}
		}
	}
}
