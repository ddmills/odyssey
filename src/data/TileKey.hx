package data;

enum TileKey
{
	TK_UNKNOWN;
	AK_UNKNOWN_1;
	AK_UNKNOWN_2;
	AK_UNKNOWN_3;
	AK_UNKNOWN_4;
	AK_UNKNOWN_5;
	AK_UNKNOWN_6;
	AK_UNKNOWN_7;
	AK_UNKNOWN_8;
	GRASS_V1_1;
	GRASS_V1_2;
	GRASS_V1_3;
	GRASS_V1_4;
	GRASS_V2_1;
	GRASS_V2_2;
	GRASS_V2_3;
	GRASS_V2_4;
	GRASS_V2_5;
	SWAMP_V1_1;
	SWAMP_V1_2;
	SWAMP_V1_3;
	SWAMP_V1_4;
	SWAMP_V2_1;
	SWAMP_V2_2;
	SWAMP_V2_3;
	SWAMP_V2_4;
	TERRAIN_BASIC_1;
	TERRAIN_BASIC_2;
	TERRAIN_BASIC_3;
	TERRAIN_BASIC_4;
	TERRAIN_BASIC_5;
	SAND_1;
	SAND_2;
	SAND_3;
	SAND_4;
	PLAYER_1;
	PLAYER_2;
	PLAYER_3;
	PLAYER_4;
	PLAYER_5;
	BANDIT_1;
	BANDIT_2;
	BANDIT_3;
	BANDIT_4;
	BANDIT_5;
	VILLAGER_1;
	VILLAGER_2;
	VILLAGER_3;
	VILLAGER_4;
	FLOWER_1;
	FLOWER_2;
	FLOWER_3;
	FLOWER_4;
	BUSH_1;
	RASPBERRY;
	WOLF;
	SNAKE;
	BAT;
	MOUNTAIN_LION;
	BEAR;
	CORPSE_SNAKE;
	CORPSE_HUMAN;
	STICK;
	EYE_OPEN;
	EYE_CLOSE;
	CURSOR;
	CURSOR_SPIN_1;
	CURSOR_SPIN_2;
	CURSOR_SPIN_3;
	CURSOR_SPIN_4;
	CURSOR_SPIN_5;
	ARROW_BOUNCE_1;
	ARROW_BOUNCE_2;
	ARROW_BOUNCE_3;
	ARROW_BOUNCE_4;
	ARROW_BOUNCE_5;
	LIQUID_SPURT_1;
	LIQUID_SPURT_2;
	LIQUID_SPURT_3;
	LIQUID_SPURT_4;
	LIQUID_SPURT_5;
	EXPLOSION_1;
	EXPLOSION_2;
	EXPLOSION_3;
	EXPLOSION_4;
	EXPLOSION_5;
	CACTUS_1;
	CACTUS_2;
	CACTUS_1_FLOWER;
	CACTUS_2_FLOWER;
	DOT;
	FILLED_SQUARE;
	FLOORBOARDS;
	ARROW_NW;
	ARROW_N;
	ARROW_NE;
	ARROW_W;
	ARROW_E;
	ARROW_SW;
	ARROW_S;
	ARROW_SE;
	TEXT_CURSOR;
	LIST_DASH;
	LIST_ARROW;
	CHEST_LARGE_OPEN;
	CHEST_LARGE_CLOSED;
	CHEST_SMALL_OPEN;
	CHEST_SMALL_CLOSED;
	PISTOL_1;
	PISTOL_2;
	PISTOL_3;
	PISTOL_4;
	SHOTGUN_1;
	RIFLE;
	PONCHO;
	DUSTER;
	LONG_JOHNS;
	BLOOD_SPATTER;
	THUG_1;
	THUG_2;
	CARTON;
	WATER_1;
	WATER_2;
	WATER_3;
	WATER_4;
	TREE_BALD_CYPRESS_1;
	TREE_BALD_CYPRESS_2;
	TREE_BALD_CYPRESS_3;
	TREE_PINE_1;
	TREE_PINE_2;
	TREE_PINE_3;
	TREE_PINE_4;
	TREE_OAK_1;
	TREE_OAK_2;
	TREE_OAK_3;
	TREE_OAK_4;
	ROCK_ROUND_1;
	ROCK_ROUND_2;
	ROCK_ROUND_3;
	ROCK_ROUND_4;
	CAMPFIRE_1;
	CAMPFIRE_2;
	CAMPFIRE_3;
	LANTERN;
	PILE_ASH;
	PLANK;
	LOG;
	BEDROLL;
	VIAL;
	WAGON_WHEEL;
	BOOTS;
	COWBOY_HAT_1;
	COWBOY_HAT_2;
	PANTS_1;
	COAT;
	APPLE;
	DYNAMITE;
	PUDDLE_1;
	JAR;
	TOMBSTONE_1;
	CROSS;
	SIGNPOST;
	OVERWORLD_FOREST;
	OVERWORLD_PRAIRIE;
	OVERWORLD_DESERT;
	OVERWORLD_SWAMP;
	OVERWORLD_TUNDRA;
	OVERWORLD_RIVER;
	OVERWORLD_TOWN;
	WALL_0; // ║
	WALL_1; // .
	WALL_2; // ╔
	WALL_3; // ╗
	WALL_4; // ║
	WALL_5; // ═
	WALL_6; // ╚
	WALL_7; // ╝
	WALL_8; // ╦
	WALL_9; // ╩
	WALL_10; // ╬
	WALL_11; // ?
	WALL_12; // ?
	WALL_13; // ?
	WALL_14; // ?
	WALL_15; // ?
	WALL_THICK_0_0;
	WALL_THICK_0_1;
	WALL_THICK_0_2;
	WALL_THICK_0_3;
	WALL_THICK_0_4;
	WALL_THICK_0_5;
	WALL_THICK_0_6;
	WALL_THICK_0_7;
	WALL_THICK_0_8;
	WALL_THICK_0_9;
	WALL_THICK_0_10;
	WALL_THICK_0_11;
	WALL_THICK_1_0;
	WALL_THICK_1_1;
	WALL_THICK_1_2;
	WALL_THICK_1_3;
	WALL_THICK_1_4;
	WALL_THICK_1_5;
	WALL_THICK_1_6;
	WALL_THICK_1_7;
	WALL_THICK_1_8;
	WALL_THICK_1_9;
	WALL_THICK_1_10;
	WALL_THICK_1_11;
	WALL_THICK_2_0;
	WALL_THICK_2_1;
	WALL_THICK_2_2;
	WALL_THICK_2_3;
	WALL_THICK_2_4;
	WALL_THICK_2_5;
	WALL_THICK_2_6;
	WALL_THICK_2_7;
	WALL_THICK_2_8;
	WALL_THICK_2_9;
	WALL_THICK_2_10;
	WALL_THICK_2_11;
	WALL_THICK_3_0;
	WALL_THICK_3_1;
	WALL_THICK_3_2;
	WALL_THICK_3_3;
	WALL_THICK_3_4;
	WALL_THICK_3_5;
	WALL_THICK_3_6;
	WALL_THICK_3_7;
	WALL_THICK_3_8;
	WALL_THICK_3_9;
	WALL_THICK_3_10;
	WALL_THICK_3_11;
	WALL_WINDOW_H;
	WALL_WINDOW_V;
	WALL_BASIC_FILL;
	WALL_BASIC_0;
	WALL_BASIC_1;
	WALL_BASIC_2;
	DOOR;
	DOOR_OPEN;
	FURNITURE_TABLE;
	FURNITURE_CHAIR;
	FURNITURE_CABINET;
	FURNITURE_CABINET_OPEN;
	FURNITURE_TALL_CABINET;
	FURNITURE_TALL_CABINET_OPEN;
	FURNITURE_SHELF;
	FURNITURE_BOOKSHELF;
	FENCE_IRON_0; // ║
	FENCE_IRON_1; // .
	FENCE_IRON_2; // ╔
	FENCE_IRON_3; // ╗
	FENCE_IRON_4; // ║
	FENCE_IRON_5; // ═
	FENCE_IRON_6; // ╚
	FENCE_IRON_7; // ╝
	FENCE_IRON_8; // ╦
	FENCE_IRON_9; // ╩
	FENCE_IRON_10; // ╬
	FENCE_IRON_11; // ?
	FENCE_IRON_12; // ?
	FENCE_IRON_13; // ?
	FENCE_IRON_14; // ?
	FENCE_IRON_15; // ?
	FENCE_BARBED_0; // ║
	FENCE_BARBED_1; // .
	FENCE_BARBED_2; // ╔
	FENCE_BARBED_3; // ╗
	FENCE_BARBED_4; // ║
	FENCE_BARBED_5; // ═
	FENCE_BARBED_6; // ╚
	FENCE_BARBED_7; // ╝
	FENCE_BARBED_8; // ╦
	FENCE_BARBED_9; // ╩
	FENCE_BARBED_10; // ╬
	FENCE_BARBED_11; // ?
	FENCE_BARBED_12; // ?
	FENCE_BARBED_13; // ?
	FENCE_BARBED_14; // ?
	FENCE_BARBED_15; // ?
	FENCE_BARS_0; // ║
	FENCE_BARS_1; // .
	FENCE_BARS_2; // ╔
	FENCE_BARS_3; // ╗
	FENCE_BARS_4; // ║
	FENCE_BARS_5; // ═
	FENCE_BARS_6; // ╚
	FENCE_BARS_7; // ╝
	FENCE_BARS_8; // ╦
	FENCE_BARS_9; // ╩
	FENCE_BARS_10; // ╬
	FENCE_BARS_11; // ?
	FENCE_BARS_12; // ?
	FENCE_BARS_13; // ?
	FENCE_BARS_14; // ?
	FENCE_BARS_15; // ?
	RAILROAD_0; // ║
	RAILROAD_1; // .
	RAILROAD_2; // ╔
	RAILROAD_3; // ╗
	RAILROAD_4; // ║
	RAILROAD_5; // ═
	RAILROAD_6; // ╚
	RAILROAD_7; // ╝
	RAILROAD_8; // ╦
	RAILROAD_9; // ╩
	RAILROAD_10; // ╬
	RAILROAD_11; // ?
	RAILROAD_12; // ?
	RAILROAD_13; // ?
	RAILROAD_14; // ?
	RAILROAD_15; // ?
	HIGHLIGHT_0; // ║
	HIGHLIGHT_1; // .
	HIGHLIGHT_2; // ╔
	HIGHLIGHT_3; // ╗
	HIGHLIGHT_4; // ║
	HIGHLIGHT_5; // ═
	HIGHLIGHT_6; // ╚
	HIGHLIGHT_7; // ╝
	HIGHLIGHT_8; // ╦
	HIGHLIGHT_9; // ╩
	HIGHLIGHT_10; // ╬
	HIGHLIGHT_11; // ?
	HIGHLIGHT_12; // ?
	HIGHLIGHT_13; // ?
	HIGHLIGHT_14; // ?
	HIGHLIGHT_15; // ?
	HIGHLIGHT_DASH_0; // ║
	HIGHLIGHT_DASH_1; // .
	HIGHLIGHT_DASH_2; // ╔
	HIGHLIGHT_DASH_3; // ╗
	HIGHLIGHT_DASH_4; // ║
	HIGHLIGHT_DASH_5; // ═
	HIGHLIGHT_DASH_6; // ╚
	HIGHLIGHT_DASH_7; // ╝
	HIGHLIGHT_DASH_8; // ╦
	HIGHLIGHT_DASH_9; // ╩
	HIGHLIGHT_DASH_10; // ╬
	HIGHLIGHT_DASH_11; // ?
	HIGHLIGHT_DASH_12; // ?
	HIGHLIGHT_DASH_13; // ?
	HIGHLIGHT_DASH_14; // ?
	HIGHLIGHT_DASH_15; // ?
	BARS_DOOR;
	BARS_DOOR_OPEN;

	PROGRESS_BAR_0;
	PROGRESS_BAR_1;
	PROGRESS_BAR_2;
	PROGRESS_BAR_3;
	PROGRESS_BAR_4;
	PROGRESS_BAR_5;
	PROGRESS_BAR_6;
	PROGRESS_BAR_7;
	PROGRESS_BAR_8;
	PROGRESS_BAR_9;
	PROGRESS_BAR_10;
	PROGRESS_BAR_11;
	PROGRESS_BAR_12;
	PROGRESS_BAR_13;
	PROGRESS_BAR_14;
}
