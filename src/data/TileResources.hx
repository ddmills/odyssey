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

	public static function Init()
	{
		GRASS_1 = hxd.Res.tiles.scroll.grass_1.toTile();
		GRASS_2 = hxd.Res.tiles.scroll.grass_2.toTile();
		GRASS_3 = hxd.Res.tiles.scroll.grass_3.toTile();
		GRASS_4 = hxd.Res.tiles.scroll.grass_4.toTile();
		SNAKE_1 = hxd.Res.tiles.scroll.snake_1.toTile();
		HERO = hxd.Res.tiles.scroll.hero.toTile();
	}
}
