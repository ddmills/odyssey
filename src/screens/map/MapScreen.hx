package screens.map;

import common.struct.IntPoint;
import core.Screen;
import core.input.KeyCode;
import data.BiomeType;
import data.ColorKeys;
import data.TileKey;
import data.TileResources;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import shaders.SpriteShader;

class MapScreen extends Screen
{
	var ob:Object;
	var granularity = 32;
	var tileSize = 16;

	public function new()
	{
		ob = new Object();
		ob.scale(2);
	}

	function getTileKey(biome:BiomeType):TileKey
	{
		return switch biome
		{
			case DESERT: OVERWORLD_DESERT;
			case SWAMP: OVERWORLD_SWAMP;
			case PRAIRIE: OVERWORLD_PRAIRIE;
			case TUNDRA: OVERWORLD_TUNDRA;
			case FOREST: OVERWORLD_FOREST;
			case _: TK_UNKNOWN;
		}
	}

	function populateTile(pos:IntPoint)
	{
		var cell = world.map.getCell(pos);
		var tileKey = getTileKey(cell.biomeKey);
		var color = world.map.getColor(pos);
		var tile = TileResources.Get(tileKey);
		var bm = new Bitmap(tile);
		var shader = new SpriteShader(color, ColorKeys.C_BLACK_1);
		shader.clearBackground = 1;
		bm.addShader(shader);
		bm.x = (pos.x / granularity).floor() * game.TILE_W;
		bm.y = (pos.y / granularity).floor() * game.TILE_H;
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
		granularity = world.chunkSize * 2;
		ob.visible = true;
		populateMap();
		var white = Tile.fromColor(ColorKeys.C_WHITE_1, game.TILE_W, game.TILE_H, 0);
		var red = Tile.fromColor(ColorKeys.C_RED_1, game.TILE_W, game.TILE_H);
		var blink = new Anim([white, red], 6);

		blink.x = (world.player.x / granularity).floor() * game.TILE_W;
		blink.y = (world.player.y / granularity).floor() * game.TILE_H;
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
