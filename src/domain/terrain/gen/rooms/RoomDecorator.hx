package domain.terrain.gen.rooms;

import core.Game;
import hxd.Rand;

abstract class RoomDecorator
{
	public function new() {}

	public abstract function decorate(r:Rand, room:Room, poi:ZonePoi):Void;

	function spawnPortals(room:Room, r:Rand)
	{
		var emptyTiles = room.getEmptyTiles();

		for (portalId in room.portals)
		{
			trace('spawn portal $portalId');

			var targetTile = r.pick(emptyTiles);
			emptyTiles.remove(targetTile);

			var portal = Game.instance.world.portals.get(portalId);

			targetTile.value.content = [
				{
					spawnableType: portal.spawnable,
					spawnableSettings: {
						portalId: portalId,
					}
				}
			];
		}
	}
}
