package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKey;
import data.TileKey;
import domain.prefabs.Spawner;
import domain.terrain.biomes.Biome.MapIconData;

class MountainBiome extends Biome
{
	public function new(seed:Int)
	{
		super(seed, MOUNTAIN, 0x0F1D22);
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		cell.tileKey = r.pick([GRASS_V1_1, GRASS_V1_2, TERRAIN_BASIC_1, TERRAIN_BASIC_2]);
		cell.terrain = TERRAIN_GRASS;
		var c = r.pick([C_DARK_GREEN, C_GRAY, C_DARK_GRAY, C_DARK_GRAY, C_DARK_GRAY]);
		cell.primary = c;
		cell.background = C_GREEN;
	}

	override function getMapIcon():MapIconData
	{
		return {
			primary: ColorKey.C_GRAY,
			secondary: ColorKey.C_CLEAR,
			background: ColorKey.C_PURPLE,
			tileKey: r.pick([TileKey.OVERWORLD_MOUNTAIN_1, TileKey.OVERWORLD_MOUNTAIN_2]),
		};
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_WATER)
		{
			return;
		}

		var rocks = perlin.get(pos, 10, 3);
		var trees = perlin.get(pos, 4, 1);

		if (rocks > .55)
		{
			Spawner.Spawn(ROCK, pos.asWorld());
		}
		else if (trees > .7)
		{
			Spawner.Spawn(PINE_TREE, pos.asWorld());
		}
	}
}
