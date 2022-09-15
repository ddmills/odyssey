package screens.map;

import common.struct.IntPoint;
import core.Screen;
import core.input.KeyCode;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;

class MapScreen extends Screen
{
	var ob:Object;
	var granularity = 2;
	var tileSize = 5;

	public function new()
	{
		ob = new Object();
	}

	function populateTile(pos:IntPoint)
	{
		var color = world.map.getColor(pos);
		var tile = Tile.fromColor(color, tileSize, tileSize);
		var bm = new Bitmap(tile);

		bm.x = (pos.x / granularity).floor() * tileSize;
		bm.y = (pos.y / granularity).floor() * tileSize;
		ob.addChild(bm);
	}

	function populateMap()
	{
		var w = (world.mapWidth / granularity).floor();
		var h = (world.mapHeight / granularity).floor();

		for (x in 0...w)
		{
			for (y in 0...h)
			{
				var wx = (x * granularity + (granularity / 2)).floor();
				var wy = (y * granularity + (granularity / 2)).floor();

				populateTile({x: wx, y: wy});
			}
		}
	}

	override function onEnter()
	{
		ob.visible = true;
		populateMap();
		var white = Tile.fromColor(0xd2d6b6, tileSize, tileSize, 0);
		var red = Tile.fromColor(0xe91e63, tileSize, tileSize);
		var blink = new Anim([white, red], 6);

		blink.x = (world.player.x / granularity).floor() * tileSize;
		blink.y = (world.player.y / granularity).floor() * tileSize;
		ob.addChild(blink);
		game.render(HUD, ob);
	}

	override function onResume()
	{
		ob.visible = true;
	}

	override function onSuspend()
	{
		ob.visible = false;
	}

	override function onDestroy()
	{
		ob.remove();
	}

	override function onKeyDown(key:KeyCode)
	{
		if (key == KEY_M)
		{
			game.input.next();
			game.screens.pop();
		}
	}
}
