package domain.terrain.biomes;

import common.struct.IntPoint;
import common.struct.WeightedTable;
import data.ColorKey;
import data.TileKey;
import domain.prefabs.Spawner;
import domain.terrain.biomes.Biome.MapIconData;

class TundraBiome extends Biome
{
	var icons:WeightedTable<MapIconData>;

	public function new(seed:Int)
	{
		super(seed, TUNDRA, 0x162427);

		icons = new WeightedTable();

		icons.add({
			primary: ColorKey.C_GRAY,
			secondary: ColorKey.C_WHITE,
			background: ColorKey.C_PURPLE,
			tileKey: TileKey.OVERWORLD_TUNDRA_1,
		}, 8);
		icons.add({
			primary: ColorKey.C_GRAY,
			secondary: ColorKey.C_WOOD,
			background: ColorKey.C_PURPLE,
			tileKey: TileKey.OVERWORLD_TUNDRA_2,
		}, 1);
	}

	override function getMapIcon():MapIconData
	{
		return icons.pick(r);
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		if (r.bool(.1))
		{
			cell.tileKey = GRASS_V1_2;
			cell.terrain = TERRAIN_GRASS;
			cell.primary = C_WHITE;
		}
		else
		{
			var t = r.pick([TERRAIN_BASIC_1, TERRAIN_BASIC_2, TERRAIN_BASIC_3]);
			cell.tileKey = t;
			cell.terrain = TERRAIN_SNOW;
			var c = r.pick([C_GRAY, C_WHITE]);
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
