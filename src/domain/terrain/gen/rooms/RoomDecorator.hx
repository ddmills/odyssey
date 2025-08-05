package domain.terrain.gen.rooms;

import core.Game;
import hxd.Rand;

abstract class RoomDecorator
{
	public function new() {}

	public abstract function decorate(r:Rand, room:Room, poi:ZonePoi):Void;

	function spawnContent(room:Room, r:Rand)
	{
		var emptyTiles = room.getEmptyTiles();

		for (content in room.content)
		{
			var targetTile = r.pick(emptyTiles);
			emptyTiles.remove(targetTile);

			targetTile.value.content = [content];
		}
	}
}
