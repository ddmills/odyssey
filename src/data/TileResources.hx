package data;

import h2d.Tile;

class TileResources
{
	public static var GRASS_1:Tile;
	public static var GRASS_2:Tile;
	public static var GRASS_3:Tile;
	public static var GRASS_4:Tile;
	public static var HERO:Tile;
	public static var SNAKE_1:Tile;
	public static var STICK_1:Tile;
	public static var EYE_OPEN:Tile;
	public static var EYE_CLOSE:Tile;
	public static var CURSOR:Tile;

	public static var CACTUS_1:Tile;
	public static var CACTUS_2:Tile;
	public static var CACTUS_1_FLOWER:Tile;
	public static var CACTUS_2_FLOWER:Tile;

	public static var DOT:Tile;
	public static var ARROW_NW:Tile;
	public static var ARROW_N:Tile;
	public static var ARROW_NE:Tile;
	public static var ARROW_W:Tile;
	public static var ARROW_E:Tile;
	public static var ARROW_SW:Tile;
	public static var ARROW_S:Tile;
	public static var ARROW_SE:Tile;

	public static var LIST_DASH:Tile;
	public static var LIST_ARROW:Tile;

	public static var CHEST_LARGE_OPEN:Tile;
	public static var CHEST_LARGE_CLOSED:Tile;

	public static var CHEST_SMALL_OPEN:Tile;
	public static var CHEST_SMALL_CLOSED:Tile;

	public static var PISTOL:Tile;
	public static var PONCHO:Tile;

	public static function Init()
	{
		GRASS_1 = hxd.Res.tiles.scroll.grass_1.toTile();
		GRASS_2 = hxd.Res.tiles.scroll.grass_2.toTile();
		GRASS_3 = hxd.Res.tiles.scroll.grass_3.toTile();
		GRASS_4 = hxd.Res.tiles.scroll.grass_4.toTile();
		SNAKE_1 = hxd.Res.tiles.scroll.snake_1.toTile();
		STICK_1 = hxd.Res.tiles.scroll.stick_1.toTile();
		HERO = hxd.Res.tiles.scroll.hero.toTile();
		EYE_OPEN = hxd.Res.tiles.scroll.eye.toTile();
		EYE_CLOSE = hxd.Res.tiles.scroll.eye_closed.toTile();
		CURSOR = hxd.Res.tiles.scroll.cursor.toTile();

		LIST_DASH = hxd.Res.tiles.scroll.list_dash.toTile();
		LIST_ARROW = hxd.Res.tiles.scroll.list_arrow.toTile();

		var catus = hxd.Res.tiles.scroll.cacti.toTile().divide(4, 1);
		CACTUS_1 = catus[0][0];
		CACTUS_2 = catus[0][1];
		CACTUS_1_FLOWER = catus[0][2];
		CACTUS_2_FLOWER = catus[0][3];

		var arrows = hxd.Res.tiles.scroll.arrows.toTile().divide(3, 3);
		ARROW_NW = arrows[0][0];
		ARROW_N = arrows[1][0];
		ARROW_NE = arrows[2][0];
		ARROW_W = arrows[0][1];
		ARROW_E = arrows[2][1];
		ARROW_SW = arrows[0][2];
		ARROW_S = arrows[1][2];
		ARROW_SE = arrows[2][2];
		DOT = arrows[1][1];

		var chestLg = hxd.Res.tiles.scroll.chest_large.toTile().divide(2, 1);
		CHEST_LARGE_CLOSED = chestLg[0][0];
		CHEST_LARGE_OPEN = chestLg[0][1];

		var chestSm = hxd.Res.tiles.scroll.chest_small.toTile().divide(2, 1);
		CHEST_SMALL_CLOSED = chestSm[0][0];
		CHEST_SMALL_OPEN = chestSm[0][1];

		PISTOL = hxd.Res.tiles.scroll.pistol.toTile();
		PONCHO = hxd.Res.tiles.scroll.poncho.toTile();
	}
}
