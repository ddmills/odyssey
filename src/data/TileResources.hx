package data;

import h2d.Tile;

class TileResources
{
	public static var GRASS1:Tile;
	public static var GRASS2:Tile;
	public static var GRASS3:Tile;
	public static var GRASS4:Tile;
	public static var HERO:Tile;

	public static function Init()
	{
		GRASS1 = hxd.Res.tiles.scroll.grass_1.toTile();
		GRASS2 = hxd.Res.tiles.scroll.grass_2.toTile();
		GRASS3 = hxd.Res.tiles.scroll.grass_3.toTile();
		GRASS4 = hxd.Res.tiles.scroll.grass_4.toTile();
		HERO = hxd.Res.tiles.scroll.hero.toTile();
	}
}
