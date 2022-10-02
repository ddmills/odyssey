package domain.terrain.gen;

import data.ColorKey;
import data.TileKey;

@:structInit class RoomTile
{
	public var content:Array<RoomContent>;
	public var tileKey:Null<TileKey>;
	public var primary:Null<ColorKey>;
	public var secondary:Null<ColorKey>;
	public var background:Null<ColorKey>;

	public function new(content:Array<RoomContent>)
	{
		this.content = content;
	}
}
