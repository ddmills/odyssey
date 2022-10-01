package domain.terrain.gen;

@:structInit class RoomTile
{
	public var content:Array<RoomContent>;

	public function new(content:Array<RoomContent>)
	{
		this.content = content;
	}
}
