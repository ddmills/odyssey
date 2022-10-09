package domain.terrain.gen;

import data.ColorKey;
import data.TileKey;

typedef RoomTile =
{
	content:Array<RoomContent>,
	?tileKey:Null<TileKey>,
	?primary:Null<ColorKey>,
	?secondary:Null<ColorKey>,
	?background:Null<ColorKey>,
}
