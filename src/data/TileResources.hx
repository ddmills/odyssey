package data;

import h2d.Tile;

class TileResources
{
	public static var GRASS:Tile;
	public static var HERO:Tile;

	public static function Init()
	{
		GRASS = Tile.fromColor(0x57723a, 16, 16);
		HERO = hxd.Res.tiles.scroll.hero.toTile();
	}
}
