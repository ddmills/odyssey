package domain.terrain.gen;

import data.SpawnableType;
import hxd.Rand;

class ZoneGenerator
{
	public static function Generate(zoneId:Int):ZoneTemplate
	{
		var template = new ZoneTemplate(zoneId);
		var r = new Rand(zoneId);

		var room = new Room(3, 3, 8, 8);

		room.tiles.fillFn((i) ->
		{
			var p = room.tiles.coord(i);
			var t = new RoomTile([]);
			if (p.x == 0 || p.y == 0 || p.x == 7 || p.y == 7)
			{
				if (p.x == 4)
				{
					t.content.push({
						spawnableType: WOOD_WALL_WINDOW,
						spawnableSettings: {},
					});
				}
				else
				{
					t.content.push({
						spawnableType: WOOD_WALL,
						spawnableSettings: {},
					});
				}
			}
			else
			{
				if (r.bool(.2))
				{
					var spawnables:Array<SpawnableType> = [TOMBSTONE, CORPSE_HUMAN, CORPSE_SNAKE];
					t.content.push({
						spawnableType: r.pick(spawnables),
						spawnableSettings: {},
					});
				}
			}

			return t;
		});

		template.rooms.push(room);

		return template;
	}
}
