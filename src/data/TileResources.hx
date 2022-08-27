package data;

import h2d.Tile;

class TileResources
{
	public static var GRASS:Tile;
	public static var HUMAN:Tile;

	public static function Init()
	{
		GRASS = Tile.fromColor(0x57723a, 16, 16);
		HUMAN = Tile.fromColor(0xe39f9b, 16, 16);
	}
}
