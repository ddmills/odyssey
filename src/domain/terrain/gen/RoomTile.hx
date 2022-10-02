package domain.terrain.gen;

import data.TileKey;

@:structInit class RoomTile
{
	public var content:Array<RoomContent>;
	public var tileKey:Null<TileKey>;
	public var primary:Null<Int>;
	public var secondary:Null<Int>;
	public var background:Null<Int>;

	public function new(content:Array<RoomContent>)
	{
		this.content = content;
	}
}
