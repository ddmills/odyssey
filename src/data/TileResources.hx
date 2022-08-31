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
	public static var DOT:Tile;

	public static var CACTUS_1:Tile;
	public static var CACTUS_2:Tile;
	public static var CACTUS_1_FLOWER:Tile;
	public static var CACTUS_2_FLOWER:Tile;

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
		DOT = hxd.Res.tiles.scroll.dot.toTile();

		var catus = hxd.Res.tiles.scroll.cacti.toTile().divide(4, 1);
		CACTUS_1 = catus[0][0];
		CACTUS_2 = catus[0][1];
		CACTUS_1_FLOWER = catus[0][2];
		CACTUS_2_FLOWER = catus[0][3];
	}
}
