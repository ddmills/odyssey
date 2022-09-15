package data;

import h2d.Tile;

class TileResources
{
	public static var tiles:Map<TileKey, Tile> = [];

	public static function Get(key:TileKey):Tile
	{
		if (key == null)
		{
			return null;
		}
		return tiles.get(key);
	}

	public static function Init()
	{
		var t = hxd.Res.tiles.scroll;

		tiles.set(GRASS_1, t.grass_1.toTile());
		tiles.set(GRASS_2, t.grass_2.toTile());
		tiles.set(GRASS_3, t.grass_3.toTile());
		tiles.set(GRASS_4, t.grass_4.toTile());
		tiles.set(SNAKE_1, t.snake_1.toTile());
		tiles.set(CORPSE_SNAKE, t.snake_corpse.toTile());
		tiles.set(CORPSE_HUMAN, t.corpse_human.toTile());
		tiles.set(STICK_1, t.stick_1.toTile());
		tiles.set(HERO, t.hero.toTile());
		tiles.set(EYE_OPEN, t.eye.toTile());
		tiles.set(EYE_CLOSE, t.eye_closed.toTile());
		tiles.set(CURSOR, t.cursor.toTile());
		tiles.set(LIST_DASH, t.list_dash.toTile());
		tiles.set(LIST_ARROW, t.list_arrow.toTile());
		tiles.set(RIFLE, t.rifle.toTile());
		tiles.set(PISTOL_1, t.pistol_1.toTile());
		tiles.set(PISTOL_2, t.pistol_2.toTile());
		tiles.set(PISTOL_3, t.pistol_3.toTile());
		tiles.set(PISTOL_4, t.pistol_4.toTile());
		tiles.set(COACH_GUN, t.shotgun.toTile());
		tiles.set(PONCHO, t.poncho.toTile());
		tiles.set(DUSTER, t.duster.toTile());
		tiles.set(LONG_JOHNS, t.longjohns.toTile());
		tiles.set(BLOOD_SPATTER, t.blood_spatter_1.toTile());
		tiles.set(THUG_1, t.thug_1.toTile());
		tiles.set(THUG_2, t.thug_2.toTile());
		tiles.set(TEXT_CURSOR, t.text_cursor.toTile());
		tiles.set(CARTON_1, t.carton_1.toTile());
		tiles.set(WATER_1, t.water_1.toTile());

		var catus = hxd.Res.tiles.scroll.cacti.toTile().divide(4, 1);
		tiles.set(CACTUS_1, catus[0][0]);
		tiles.set(CACTUS_2, catus[0][1]);
		tiles.set(CACTUS_1_FLOWER, catus[0][2]);
		tiles.set(CACTUS_2_FLOWER, catus[0][3]);

		var arrows = hxd.Res.tiles.scroll.arrows.toTile().divide(3, 3);
		tiles.set(ARROW_NW, arrows[0][0]);
		tiles.set(ARROW_N, arrows[1][0]);
		tiles.set(ARROW_NE, arrows[2][0]);
		tiles.set(ARROW_W, arrows[0][1]);
		tiles.set(ARROW_E, arrows[2][1]);
		tiles.set(ARROW_SW, arrows[0][2]);
		tiles.set(ARROW_S, arrows[1][2]);
		tiles.set(ARROW_SE, arrows[2][2]);
		tiles.set(DOT, arrows[1][1]);

		var chestLg = t.chest_large.toTile().divide(2, 1);
		tiles.set(CHEST_LARGE_CLOSED, chestLg[0][0]);
		tiles.set(CHEST_LARGE_OPEN, chestLg[0][1]);

		var chestSm = t.chest_small.toTile().divide(2, 1);
		tiles.set(CHEST_SMALL_CLOSED, chestSm[0][0]);
		tiles.set(CHEST_SMALL_OPEN, chestSm[0][1]);

		var sands = t.sand.toTile().divide(4, 1);
		tiles.set(SAND_1, sands[0][0]);
		tiles.set(SAND_2, sands[0][1]);
		tiles.set(SAND_3, sands[0][2]);
		tiles.set(SAND_4, sands[0][3]);

		var grassv2 = t.grasses_2.toTile().divide(5, 1);
		tiles.set(GRASS_V2_1, grassv2[0][0]);
		tiles.set(GRASS_V2_2, grassv2[0][1]);
		tiles.set(GRASS_V2_3, grassv2[0][2]);
		tiles.set(GRASS_V2_4, grassv2[0][3]);
		tiles.set(GRASS_V2_5, grassv2[0][4]);

		var swamp = t.swamp.toTile().divide(5, 1);
		tiles.set(SWAMP_1, swamp[0][0]);
		tiles.set(SWAMP_2, swamp[0][1]);
		tiles.set(SWAMP_3, swamp[0][2]);
		tiles.set(SWAMP_4, swamp[0][3]);
		tiles.set(SWAMP_5, swamp[0][4]);

		var baldCypressV1 = t.bald_cypress_v1.toTile().divide(3, 1);
		tiles.set(BALD_CYPRESS_V1_1, baldCypressV1[0][0]);
		tiles.set(BALD_CYPRESS_V1_2, baldCypressV1[0][1]);
		tiles.set(BALD_CYPRESS_V1_3, baldCypressV1[0][2]);

		var baldCypressV2 = t.bald_cypress_v2.toTile().divide(3, 1);
		tiles.set(BALD_CYPRESS_V2_1, baldCypressV2[0][0]);
		tiles.set(BALD_CYPRESS_V2_2, baldCypressV2[0][1]);
		tiles.set(BALD_CYPRESS_V2_3, baldCypressV2[0][2]);

		var pineTrees = t.pine_trees_v1.toTile().divide(4, 1);
		tiles.set(PINE_TREE_1, pineTrees[0][0]);
		tiles.set(PINE_TREE_2, pineTrees[0][1]);
		tiles.set(PINE_TREE_3, pineTrees[0][2]);
		tiles.set(PINE_TREE_4, pineTrees[0][3]);

		var oakTrees = t.oak_trees_v1.toTile().divide(3, 1);
		tiles.set(OAK_TREE_1, oakTrees[0][0]);
		tiles.set(OAK_TREE_2, oakTrees[0][1]);
		tiles.set(OAK_TREE_3, oakTrees[0][2]);
	}
}
