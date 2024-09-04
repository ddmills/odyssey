package domain.terrain.biomes;

import common.struct.IntPoint;
import common.struct.WeightedTable;
import data.ColorKey;
import data.TileKey;
import domain.prefabs.Spawner;
import domain.terrain.biomes.Biome.MapIconData;

class PrairieBiome extends Biome
{
	var icons:WeightedTable<MapIconData>;

	public function new(seed:Int)
	{
		super(seed, PRAIRIE, 0x11180B);

		icons = new WeightedTable();

		icons.add({
			primary: ColorKey.C_GREEN,
			secondary: ColorKey.C_WHITE,
			background: ColorKey.C_PURPLE,
			tileKey: TileKey.OVERWORLD_PRAIRIE_1,
		}, 2);
		icons.add({
			primary: ColorKey.C_GREEN,
			secondary: ColorKey.C_WHITE,
			background: ColorKey.C_PURPLE,
			tileKey: TileKey.OVERWORLD_PRAIRIE_2,
		}, 4);
	}

	function getBackgroundTileKey(pos:IntPoint):TileKey
	{
		var h = perlin.get(pos, 6);

		if (h > .6)
		{
			return GRASS_V2_5;
		}

		if (h > .55)
		{
			return GRASS_V2_4;
		}

		if (h > .5)
		{
			return GRASS_V2_3;
		}

		if (h > .4)
		{
			return GRASS_V2_2;
		}

		if (h > .3)
		{
			return GRASS_V2_1;
		}

		return TERRAIN_BASIC_1;
	}

	public override function getMapIcon():MapIconData
	{
		return icons.pick(r);
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		cell.tileKey = getBackgroundTileKey(pos);
		cell.terrain = TERRAIN_GRASS;

		var c = r.pick([C_DARK_GREEN, C_DARK_GREEN, C_DARK_GRAY]);

		cell.primary = c;
		cell.background = C_GREEN;
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		if (cell.terrain == TERRAIN_GRASS)
		{
			var h = perlin.get(pos, 6);
			var trees = perlin.get(pos, 8, 8);
			var flowers = perlin.get(pos, 12, 8);

			if (h > .65)
			{
				Spawner.Spawn(TALL_GRASS, pos.asWorld());
			}
			else if (h > .6 && trees > .6)
			{
				Spawner.Spawn(OAK_TREE, pos.asWorld());
			}
			else if (flowers > .78)
			{
				if (r.bool(.5))
				{
					if (r.bool(.5))
					{
						Spawner.Spawn(HEMLOCK, pos.asWorld());
					}
					else
					{
						Spawner.Spawn(YARROW, pos.asWorld());
					}
				}
				else
				{
					Spawner.Spawn(LAVENDER, pos.asWorld());
				}
			}
			else if (r.bool(.005))
			{
				Spawner.Spawn(STICK, pos.asWorld());
			}
		}
	}
}
