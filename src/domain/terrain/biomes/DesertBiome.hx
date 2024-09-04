package domain.terrain.biomes;

import common.struct.IntPoint;
import common.struct.WeightedTable;
import data.ColorKey;
import data.TileKey;
import domain.prefabs.Spawner;
import domain.terrain.biomes.Biome.MapIconData;
import domain.terrain.biomes.Biome.RockData;

class DesertBiome extends Biome
{
	var icons:WeightedTable<MapIconData>;

	public function new(seed:Int)
	{
		super(seed, DESERT, 0x1B1410);

		icons = new WeightedTable();

		icons.add({
			primary: ColorKey.C_RED,
			secondary: ColorKey.C_WHITE,
			background: ColorKey.C_PURPLE,
			tileKey: TileKey.OVERWORLD_DESERT_1,
		}, 6);
		icons.add({
			primary: ColorKey.C_GREEN,
			secondary: ColorKey.C_WHITE,
			background: ColorKey.C_PURPLE,
			tileKey: TileKey.OVERWORLD_DESERT_2,
		}, 1);
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		if (r.bool(.1))
		{
			cell.tileKey = GRASS_V1_1;
			cell.terrain = TERRAIN_GRASS;
			cell.primary = C_BROWN;
		}
		else
		{
			var c = r.pick([C_BROWN, C_DARK_BROWN, C_DARK_RED]);
			var t = r.pick([TERRAIN_BASIC_1, TERRAIN_BASIC_2, TERRAIN_BASIC_3]);
			cell.tileKey = t;
			cell.terrain = TERRAIN_SAND;
			cell.primary = c;
		}

		cell.background = C_YELLOW;
	}

	override function getMapIcon():MapIconData
	{
		return icons.pick(r);
	}

	override public function getCommonRock():RockData
	{
		return {
			primary: C_RED,
			secondary: C_CLEAR,
		};
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_SAND)
		{
			var rocks = perlin.get(pos, 18, 2);
			if (rocks > .7)
			{
				Spawner.Spawn(DESERT_ROCK, pos.asWorld());
			}
			else if (r.bool(.05))
			{
				Spawner.Spawn(CACTUS, pos.asWorld());
			}
		}
	}
}
