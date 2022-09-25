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

	public function new()
	{
		ob = new Object();
		ob.scale(1);
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
		var chunk = world.chunks.getChunk(pos.x, pos.y);
		var biomeKey = chunk.biomes.ne;
		var tileKey = getTileKey(biomeKey);
		var tile = TileResources.Get(tileKey);
		var biome = world.map.getBiome(biomeKey);
		var bm = new Bitmap(tile);
		var shader = new SpriteShader(biome.naturalColor, ColorKeys.C_BLACK_1);
		shader.clearBackground = 1;
		bm.addShader(shader);
		bm.x = pos.x * game.TILE_W;
		bm.y = pos.y * game.TILE_H;
		ob.addChild(bm);
	}

	function populateMap()
	{
		for (x in 0...world.chunkCountX)
		{
			for (y in 0...world.chunkCountY)
			{
				populateTile({x: x, y: y});
			}
		}
	}

	override function onEnter()
	{
		ob.visible = true;
		populateMap();
		var white = Tile.fromColor(ColorKeys.C_WHITE_1, game.TILE_W, game.TILE_H, 0);
		var red = Tile.fromColor(ColorKeys.C_RED_1, game.TILE_W, game.TILE_H);
		var blink = new Anim([white, red], 6);

		var blinkPos = world.player.pos.toChunk().toIntPoint();
		blink.x = blinkPos.x * game.TILE_W;
		blink.y = blinkPos.y * game.TILE_H;
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
