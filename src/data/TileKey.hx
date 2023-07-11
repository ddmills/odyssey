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
	PERSON_1;
	PERSON_2;
	PERSON_3;
	PERSON_4;
	PERSON_5;
	PERSON_6;
	PERSON_7;
	PERSON_8;
	PERSON_9;
	PERSON_10;
	PERSON_11;
	PERSON_12;
	WOLF;
	SNAKE;
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
	CAMPFIRE_1;
	CAMPFIRE_2;
	CAMPFIRE_3;
	LANTERN;
	PILE_ASH;
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
	WALL_WINDOW_H;
	WALL_WINDOW_V;
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
	BARS_DOOR;
	BARS_DOOR_OPEN;
}
