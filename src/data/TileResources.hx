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

		var tile = tiles.get(key);

		if (tile == null)
		{
			return tiles.get(TK_UNKNOWN);
		}

		return tile;
	}

	public static function Init()
	{
		var t = hxd.Res.tiles.smol.sheet_14_14.toTile().divide(16, 16);
		tiles.set(TK_UNKNOWN, t[0][7]);

		tiles.set(GRASS_V1_1, t[0][0]);
		tiles.set(GRASS_V1_2, t[0][1]);
		tiles.set(GRASS_V1_3, t[0][2]);
		tiles.set(GRASS_V1_4, t[0][3]);
		tiles.set(GRASS_V2_1, t[0][0]);
		tiles.set(GRASS_V2_2, t[0][1]);
		tiles.set(GRASS_V2_3, t[0][2]);
		tiles.set(GRASS_V2_4, t[0][3]);
		tiles.set(SWAMP_V1_1, t[3][0]);
		tiles.set(SWAMP_V1_2, t[3][1]);
		tiles.set(SWAMP_V1_3, t[3][2]);
		tiles.set(SWAMP_V1_4, t[3][3]);
		tiles.set(SWAMP_V2_1, t[3][0]);
		tiles.set(SWAMP_V2_2, t[3][1]);
		tiles.set(SWAMP_V2_3, t[3][2]);
		tiles.set(SWAMP_V2_4, t[3][3]);

		tiles.set(WATER_1, t[2][2]);
		tiles.set(WATER_2, t[2][1]);
		tiles.set(WATER_3, t[2][2]);
		tiles.set(WATER_4, t[2][3]);

		tiles.set(CAMPFIRE_1, t[0][8]);
		tiles.set(CAMPFIRE_2, t[0][9]);
		tiles.set(CAMPFIRE_3, t[0][10]);

		tiles.set(PERSON_1, t[5][0]);
		tiles.set(PERSON_2, t[5][1]);
		tiles.set(PERSON_3, t[5][2]);
		tiles.set(PERSON_4, t[5][3]);
		tiles.set(PERSON_5, t[5][4]);
		tiles.set(PERSON_6, t[5][5]);
		tiles.set(PERSON_7, t[5][6]);
		tiles.set(PERSON_8, t[5][7]);

		tiles.set(TERRAIN_BASIC_1, t[1][0]);
		tiles.set(TERRAIN_BASIC_2, t[1][1]);
		tiles.set(TERRAIN_BASIC_3, t[1][2]);
		tiles.set(TERRAIN_BASIC_4, t[1][3]);

		tiles.set(TREE_BALD_CYPRESS_1, t[4][2]);
		tiles.set(TREE_BALD_CYPRESS_2, t[4][2]);
		tiles.set(TREE_BALD_CYPRESS_3, t[4][2]);
		tiles.set(TREE_PINE_1, t[4][0]);
		tiles.set(TREE_PINE_2, t[4][0]);
		tiles.set(TREE_PINE_3, t[4][0]);
		tiles.set(TREE_PINE_4, t[4][0]);
		tiles.set(TREE_OAK_1, t[4][1]);
		tiles.set(TREE_OAK_2, t[4][1]);
		tiles.set(TREE_OAK_3, t[4][1]);
		tiles.set(TREE_OAK_4, t[4][1]);
		tiles.set(CACTUS_1, t[4][3]);
		tiles.set(CACTUS_2, t[4][3]);
		tiles.set(CACTUS_1_FLOWER, t[4][4]);
		tiles.set(CACTUS_2_FLOWER, t[4][4]);

		tiles.set(BLOOD_SPATTER, t[2][4]);
		tiles.set(LANTERN, t[1][6]);

		tiles.set(RIFLE, t[0][5]);
		tiles.set(PISTOL_1, t[0][4]);
		tiles.set(PISTOL_2, t[0][4]);
		tiles.set(PISTOL_3, t[0][4]);
		tiles.set(PISTOL_4, t[0][4]);
		tiles.set(SHOTGUN_1, t[0][6]);

		tiles.set(CHEST_LARGE_CLOSED, t[1][4]);
		tiles.set(CHEST_LARGE_OPEN, t[1][5]);
		tiles.set(CHEST_SMALL_CLOSED, t[1][4]);
		tiles.set(CHEST_SMALL_OPEN, t[1][5]);

		tiles.set(SNAKE_1, t[6][1]);

		tiles.set(CURSOR, t[6][0]);
		tiles.set(DOT, t[1][0]);

		tiles.set(LIST_DASH, t[7][0]);
		tiles.set(LIST_ARROW, t[7][1]);
		// tiles.set(CORPSE_SNAKE, t.snake_corpse.toTile());
		// tiles.set(CORPSE_HUMAN, t.corpse_human.toTile());
		// tiles.set(STICK_1, t.stick_1.toTile());

		// var t = hxd.Res.tiles.scroll;

		// var grass = t.grass_png.toTile().divide(4, 4);
		// tiles.set(GRASS_V1_1, grass[0][0]);
		// tiles.set(GRASS_V1_2, grass[0][1]);
		// tiles.set(GRASS_V1_3, grass[0][2]);
		// tiles.set(GRASS_V1_4, grass[0][3]);
		// tiles.set(GRASS_V2_1, grass[1][0]);
		// tiles.set(GRASS_V2_2, grass[1][1]);
		// tiles.set(GRASS_V2_3, grass[1][2]);
		// tiles.set(GRASS_V2_4, grass[1][3]);

		// var water = t.water.toTile().divide(4, 1);
		// tiles.set(WATER_1, water[0][0]);
		// tiles.set(WATER_2, water[0][1]);
		// tiles.set(WATER_3, water[0][2]);
		// tiles.set(WATER_4, water[0][3]);

		// tiles.set(SNAKE_1, t.snake_1.toTile());
		// tiles.set(CORPSE_SNAKE, t.snake_corpse.toTile());
		// tiles.set(CORPSE_HUMAN, t.corpse_human.toTile());
		// tiles.set(STICK_1, t.stick_1.toTile());
		// tiles.set(EYE_OPEN, t.eye.toTile());
		// tiles.set(EYE_CLOSE, t.eye_closed.toTile());
		// tiles.set(CURSOR, t.cursor_2.toTile());
		// tiles.set(LIST_DASH, t.list_dash.toTile());
		// tiles.set(LIST_ARROW, t.list_arrow.toTile());

		// tiles.set(PONCHO, t.poncho.toTile());
		// tiles.set(DUSTER, t.duster.toTile());
		// tiles.set(LONG_JOHNS, t.longjohns.toTile());
		// tiles.set(BLOOD_SPATTER, t.blood_spatter_1.toTile());
		// tiles.set(THUG_1, t.thug_1.toTile());
		// tiles.set(THUG_2, t.thug_2.toTile());
		// tiles.set(TEXT_CURSOR, t.text_cursor.toTile());
		// tiles.set(CARTON_1, t.carton_1.toTile());

		// var catus = hxd.Res.tiles.scroll.cacti.toTile().divide(4, 1);
		// tiles.set(CACTUS_1, catus[0][0]);
		// tiles.set(CACTUS_2, catus[0][1]);
		// tiles.set(CACTUS_1_FLOWER, catus[0][2]);
		// tiles.set(CACTUS_2_FLOWER, catus[0][3]);

		// var arrows = hxd.Res.tiles.scroll.arrows.toTile().divide(3, 3);
		// tiles.set(ARROW_NW, arrows[0][0]);
		// tiles.set(ARROW_N, arrows[1][0]);
		// tiles.set(ARROW_NE, arrows[2][0]);
		// tiles.set(ARROW_W, arrows[0][1]);
		// tiles.set(ARROW_E, arrows[2][1]);
		// tiles.set(ARROW_SW, arrows[0][2]);
		// tiles.set(ARROW_S, arrows[1][2]);
		// tiles.set(ARROW_SE, arrows[2][2]);
		// tiles.set(DOT, arrows[1][1]);

		// var chestLg = t.chest_large.toTile().divide(2, 1);
		// tiles.set(CHEST_LARGE_CLOSED, chestLg[0][0]);
		// tiles.set(CHEST_LARGE_OPEN, chestLg[0][1]);

		// var chestSm = t.chest_small.toTile().divide(2, 1);
		// tiles.set(CHEST_SMALL_CLOSED, chestSm[0][0]);
		// tiles.set(CHEST_SMALL_OPEN, chestSm[0][1]);

		// // var sands = t.sand.toTile().divide(4, 1);
		// // tiles.set(SAND_1, sands[0][0]);
		// // tiles.set(SAND_2, sands[0][1]);
		// // tiles.set(SAND_3, sands[0][2]);
		// // tiles.set(SAND_4, sands[0][3]);

		// var basic = t.terrain_basic.toTile().divide(4, 1);
		// tiles.set(TERRAIN_BASIC_1, basic[0][0]);
		// tiles.set(TERRAIN_BASIC_2, basic[0][1]);
		// tiles.set(TERRAIN_BASIC_3, basic[0][2]);
		// tiles.set(TERRAIN_BASIC_4, basic[0][3]);

		// var mud = t.mud.toTile().divide(4, 2);
		// tiles.set(SWAMP_V1_1, mud[0][0]);
		// tiles.set(SWAMP_V1_2, mud[0][1]);
		// tiles.set(SWAMP_V1_3, mud[0][2]);
		// tiles.set(SWAMP_V1_4, mud[0][3]);
		// tiles.set(SWAMP_V2_1, mud[1][0]);
		// tiles.set(SWAMP_V2_2, mud[1][1]);
		// tiles.set(SWAMP_V2_3, mud[1][2]);
		// tiles.set(SWAMP_V2_4, mud[1][3]);

		// var baldCypressV1 = t.tree_bald_cypress.toTile().divide(3, 1);
		// tiles.set(TREE_BALD_CYPRESS_1, baldCypressV1[0][0]);
		// tiles.set(TREE_BALD_CYPRESS_2, baldCypressV1[0][1]);
		// tiles.set(TREE_BALD_CYPRESS_3, baldCypressV1[0][2]);

		// var pineTrees = t.tree_pine.toTile().divide(4, 1);
		// tiles.set(TREE_PINE_1, pineTrees[0][0]);
		// tiles.set(TREE_PINE_2, pineTrees[0][1]);
		// tiles.set(TREE_PINE_3, pineTrees[0][2]);
		// tiles.set(TREE_PINE_4, pineTrees[0][3]);

		// var oakTrees = t.tree_oak.toTile().divide(4, 1);
		// tiles.set(TREE_OAK_1, oakTrees[0][0]);
		// tiles.set(TREE_OAK_2, oakTrees[0][1]);
		// tiles.set(TREE_OAK_3, oakTrees[0][2]);
		// tiles.set(TREE_OAK_4, oakTrees[0][3]);

		// var guns = t.guns_png.toTile().divide(4, 4);
		// tiles.set(RIFLE, guns[0][0]);
		// tiles.set(PISTOL_1, guns[1][0]);
		// tiles.set(PISTOL_2, guns[1][1]);
		// tiles.set(PISTOL_3, guns[1][2]);
		// tiles.set(PISTOL_4, guns[1][3]);
		// tiles.set(SHOTGUN_1, guns[2][0]);

		// var people = t.people_png.toTile().divide(4, 4);
		// tiles.set(PERSON_1, people[0][0]);
		// tiles.set(PERSON_2, people[0][1]);
		// tiles.set(PERSON_3, people[0][2]);
		// tiles.set(PERSON_4, people[0][3]);
		// tiles.set(PERSON_5, people[1][0]);
		// tiles.set(PERSON_6, people[1][1]);
		// tiles.set(PERSON_7, people[1][2]);
		// tiles.set(PERSON_8, people[1][3]);
	}
}
