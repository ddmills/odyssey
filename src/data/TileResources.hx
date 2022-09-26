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
		// var t = hxd.Res.tiles.smol.sheet_16_24.toTile().divide(16, 16);

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
		tiles.set(PERSON_9, t[5][8]);
		tiles.set(PERSON_10, t[5][9]);
		tiles.set(PERSON_11, t[5][10]);
		tiles.set(PERSON_12, t[5][11]);

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

		tiles.set(LANTERN, t[1][6]);
		tiles.set(PILE_ASH, t[1][7]);
		tiles.set(BLOOD_SPATTER, t[2][4]);
		tiles.set(STICK, t[2][5]);
		tiles.set(CARTON, t[2][6]);
		tiles.set(APPLE, t[2][9]);
		tiles.set(JAR, t[2][10]);
		tiles.set(DUSTER, t[3][4]);
		tiles.set(LONG_JOHNS, t[3][5]);
		tiles.set(BEDROLL, t[3][6]);
		tiles.set(VIAL, t[3][7]);
		tiles.set(PONCHO, t[4][5]);
		tiles.set(WAGON_WHEEL, t[1][8]);
		tiles.set(DYNOMITE, t[1][9]);
		tiles.set(TOMBSTONE_1, t[1][10]);
		tiles.set(BOOTS, t[4][6]);
		tiles.set(COAT, t[4][7]);
		tiles.set(COWBOY_HAT_1, t[3][8]);
		tiles.set(COWBOY_HAT_2, t[4][8]);
		tiles.set(PANTS_1, t[4][9]);
		tiles.set(PUDDLE_1, t[0][12]);

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

		tiles.set(SNAKE, t[6][1]);

		tiles.set(CURSOR, t[6][0]);
		tiles.set(LIST_DASH, t[7][0]);
		tiles.set(LIST_ARROW, t[7][1]);
		tiles.set(DOT, t[7][3]);

		tiles.set(CORPSE_HUMAN, t[6][2]);
		tiles.set(CORPSE_SNAKE, t[6][3]);

		tiles.set(OVERWORLD_RIVER, t[1][15]);
		tiles.set(OVERWORLD_DESERT, t[2][11]);
		tiles.set(OVERWORLD_SWAMP, t[2][12]);
		tiles.set(OVERWORLD_TUNDRA, t[2][13]);
		tiles.set(OVERWORLD_PRAIRIE, t[2][14]);
		tiles.set(OVERWORLD_FOREST, t[2][15]);

		tiles.set(TEXT_CURSOR, hxd.Res.tiles.scroll.text_cursor.toTile());
	}
}
