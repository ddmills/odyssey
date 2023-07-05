package data;

import h2d.Tile;

class TileResources
{
	public static var tiles:Map<TileKey, Tile> = [];

	public static function Get(key:TileKey):Tile
	{
		if (key.isNull())
		{
			return null;
		}

		var tile = tiles.get(key);

		if (tile.isNull())
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
		tiles.set(TERRAIN_BASIC_5, t[8][1]);

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
		tiles.set(DYNAMITE, t[1][9]);
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
		tiles.set(CURSOR_SPIN_1, t[7][4]);
		tiles.set(CURSOR_SPIN_2, t[7][5]);
		tiles.set(CURSOR_SPIN_3, t[7][6]);
		tiles.set(CURSOR_SPIN_4, t[7][7]);
		tiles.set(CURSOR_SPIN_5, t[7][8]);
		tiles.set(ARROW_BOUNCE_1, t[8][4]);
		tiles.set(ARROW_BOUNCE_2, t[8][5]);
		tiles.set(ARROW_BOUNCE_3, t[8][6]);
		tiles.set(ARROW_BOUNCE_4, t[8][7]);

		tiles.set(LIQUID_SPURT_1, t[8][8]);
		tiles.set(LIQUID_SPURT_2, t[8][9]);
		tiles.set(LIQUID_SPURT_3, t[8][10]);
		tiles.set(LIQUID_SPURT_4, t[8][11]);
		tiles.set(LIQUID_SPURT_5, t[8][12]);
		tiles.set(EXPLOSION_1, t[9][8]);
		tiles.set(EXPLOSION_2, t[9][9]);
		tiles.set(EXPLOSION_3, t[9][10]);
		tiles.set(EXPLOSION_4, t[9][11]);
		tiles.set(EXPLOSION_5, t[9][12]);
		tiles.set(LIST_DASH, t[7][0]);
		tiles.set(LIST_ARROW, t[7][1]);
		tiles.set(DOT, t[7][3]);
		tiles.set(FLOORBOARDS, t[8][0]);

		tiles.set(CORPSE_HUMAN, t[6][2]);
		tiles.set(CORPSE_SNAKE, t[6][3]);
		tiles.set(WOLF, t[3][13]);

		tiles.set(DOOR, t[6][5]);
		tiles.set(DOOR_OPEN, t[6][6]);

		tiles.set(BARS_DOOR, t[6][7]);
		tiles.set(BARS_DOOR_OPEN, t[6][8]);

		tiles.set(OVERWORLD_TOWN, t[1][14]);
		tiles.set(OVERWORLD_RIVER, t[1][15]);
		tiles.set(OVERWORLD_DESERT, t[2][11]);
		tiles.set(OVERWORLD_SWAMP, t[2][12]);
		tiles.set(OVERWORLD_TUNDRA, t[2][13]);
		tiles.set(OVERWORLD_PRAIRIE, t[2][14]);
		tiles.set(OVERWORLD_FOREST, t[2][15]);

		tiles.set(WALL_WINDOW_H, t[0][13]);
		tiles.set(WALL_WINDOW_V, t[0][14]);

		tiles.set(TEXT_CURSOR, hxd.Res.tiles.scroll.text_cursor.toTile());

		tiles.set(FURNITURE_TABLE, t[3][12]);
		tiles.set(FURNITURE_CHAIR, t[3][11]);
		tiles.set(FURNITURE_CABINET, t[4][10]);
		tiles.set(FURNITURE_CABINET_OPEN, t[5][10]);
		tiles.set(FURNITURE_TALL_CABINET, t[4][11]);
		tiles.set(FURNITURE_TALL_CABINET_OPEN, t[5][11]);
		tiles.set(FURNITURE_BOOKSHELF, t[4][12]);
		tiles.set(FURNITURE_SHELF, t[5][12]);

		var walls = hxd.Res.tiles.smol.walls_14_14_2.toTile().divide(4, 4);
		tiles.set(WALL_0, walls[0][0]);
		tiles.set(WALL_1, walls[0][1]);
		tiles.set(WALL_2, walls[0][2]);
		tiles.set(WALL_3, walls[0][3]);
		tiles.set(WALL_4, walls[1][0]);
		tiles.set(WALL_5, walls[1][1]);
		tiles.set(WALL_6, walls[1][2]);
		tiles.set(WALL_7, walls[1][3]);
		tiles.set(WALL_8, walls[2][0]);
		tiles.set(WALL_9, walls[2][1]);
		tiles.set(WALL_10, walls[2][2]);
		tiles.set(WALL_11, walls[2][3]);
		tiles.set(WALL_12, walls[3][0]);
		tiles.set(WALL_13, walls[3][1]);
		tiles.set(WALL_14, walls[3][2]);
		tiles.set(WALL_15, walls[3][3]);

		var fenceIron = hxd.Res.tiles.smol.fence_iron_14_14.toTile().divide(4, 4);
		tiles.set(FENCE_IRON_0, fenceIron[0][0]);
		tiles.set(FENCE_IRON_1, fenceIron[0][1]);
		tiles.set(FENCE_IRON_2, fenceIron[0][2]);
		tiles.set(FENCE_IRON_3, fenceIron[0][3]);
		tiles.set(FENCE_IRON_4, fenceIron[1][0]);
		tiles.set(FENCE_IRON_5, fenceIron[1][1]);
		tiles.set(FENCE_IRON_6, fenceIron[1][2]);
		tiles.set(FENCE_IRON_7, fenceIron[1][3]);
		tiles.set(FENCE_IRON_8, fenceIron[2][0]);
		tiles.set(FENCE_IRON_9, fenceIron[2][1]);
		tiles.set(FENCE_IRON_10, fenceIron[2][2]);
		tiles.set(FENCE_IRON_11, fenceIron[2][3]);
		tiles.set(FENCE_IRON_12, fenceIron[3][0]);
		tiles.set(FENCE_IRON_13, fenceIron[3][1]);
		tiles.set(FENCE_IRON_14, fenceIron[3][2]);
		tiles.set(FENCE_IRON_15, fenceIron[3][3]);

		var fenceBarbed = hxd.Res.tiles.smol.fence_barbed_14_14.toTile().divide(4, 4);
		tiles.set(FENCE_BARBED_0, fenceBarbed[0][0]);
		tiles.set(FENCE_BARBED_1, fenceBarbed[0][1]);
		tiles.set(FENCE_BARBED_2, fenceBarbed[0][2]);
		tiles.set(FENCE_BARBED_3, fenceBarbed[0][3]);
		tiles.set(FENCE_BARBED_4, fenceBarbed[1][0]);
		tiles.set(FENCE_BARBED_5, fenceBarbed[1][1]);
		tiles.set(FENCE_BARBED_6, fenceBarbed[1][2]);
		tiles.set(FENCE_BARBED_7, fenceBarbed[1][3]);
		tiles.set(FENCE_BARBED_8, fenceBarbed[2][0]);
		tiles.set(FENCE_BARBED_9, fenceBarbed[2][1]);
		tiles.set(FENCE_BARBED_10, fenceBarbed[2][2]);
		tiles.set(FENCE_BARBED_11, fenceBarbed[2][3]);
		tiles.set(FENCE_BARBED_12, fenceBarbed[3][0]);
		tiles.set(FENCE_BARBED_13, fenceBarbed[3][1]);
		tiles.set(FENCE_BARBED_14, fenceBarbed[3][2]);
		tiles.set(FENCE_BARBED_15, fenceBarbed[3][3]);

		var fenceBars = hxd.Res.tiles.smol.fence_bars_14_14.toTile().divide(4, 4);
		tiles.set(FENCE_BARS_0, fenceBars[0][0]);
		tiles.set(FENCE_BARS_1, fenceBars[0][1]);
		tiles.set(FENCE_BARS_2, fenceBars[0][2]);
		tiles.set(FENCE_BARS_3, fenceBars[0][3]);
		tiles.set(FENCE_BARS_4, fenceBars[1][0]);
		tiles.set(FENCE_BARS_5, fenceBars[1][1]);
		tiles.set(FENCE_BARS_6, fenceBars[1][2]);
		tiles.set(FENCE_BARS_7, fenceBars[1][3]);
		tiles.set(FENCE_BARS_8, fenceBars[2][0]);
		tiles.set(FENCE_BARS_9, fenceBars[2][1]);
		tiles.set(FENCE_BARS_10, fenceBars[2][2]);
		tiles.set(FENCE_BARS_11, fenceBars[2][3]);
		tiles.set(FENCE_BARS_12, fenceBars[3][0]);
		tiles.set(FENCE_BARS_13, fenceBars[3][1]);
		tiles.set(FENCE_BARS_14, fenceBars[3][2]);
		tiles.set(FENCE_BARS_15, fenceBars[3][3]);

		var railroad = hxd.Res.tiles.smol.railroad_14_14.toTile().divide(4, 4);
		tiles.set(RAILROAD_0, railroad[0][0]);
		tiles.set(RAILROAD_1, railroad[0][1]);
		tiles.set(RAILROAD_2, railroad[0][2]);
		tiles.set(RAILROAD_3, railroad[0][3]);
		tiles.set(RAILROAD_4, railroad[1][0]);
		tiles.set(RAILROAD_5, railroad[1][1]);
		tiles.set(RAILROAD_6, railroad[1][2]);
		tiles.set(RAILROAD_7, railroad[1][3]);
		tiles.set(RAILROAD_8, railroad[2][0]);
		tiles.set(RAILROAD_9, railroad[2][1]);
		tiles.set(RAILROAD_10, railroad[2][2]);
		tiles.set(RAILROAD_11, railroad[2][3]);
		tiles.set(RAILROAD_12, railroad[3][0]);
		tiles.set(RAILROAD_13, railroad[3][1]);
		tiles.set(RAILROAD_14, railroad[3][2]);
		tiles.set(RAILROAD_15, railroad[3][3]);
	}
}
