package screens.map;

import common.struct.IntPoint;
import core.Game;
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

typedef Obs =
{
	root:Object,
	bg:Bitmap,
};

class MapScreen extends Screen
{
	var ob:Obs;

	public function new() {}

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
		var zone = world.zones.getZone(pos);
		var biomeKey = zone.biomes.nw;

		var tileKey = getTileKey(biomeKey);
		var tile = TileResources.Get(tileKey);
		var biome = world.map.getBiome(biomeKey);
		var color = biome.naturalColor;

		if (zone.biomes.river != null)
		{
			tile = TileResources.Get(OVERWORLD_RIVER);
			color = ColorKeys.C_BLUE_2;
		}

		if (zone.isTown)
		{
			tile = TileResources.Get(OVERWORLD_TOWN);
			color = ColorKeys.C_ORANGE_1;
		}

		var bm = new Bitmap(tile);
		var shader = new SpriteShader(color, ColorKeys.C_BLACK_1);
		shader.clearBackground = 1;
		bm.addShader(shader);
		bm.x = pos.x * game.TILE_W;
		bm.y = pos.y * game.TILE_H;
		ob.root.addChild(bm);
	}

	function populateMap()
	{
		for (x in 0...world.zoneCountX)
		{
			for (y in 0...world.zoneCountY)
			{
				populateTile({x: x, y: y});
			}
		}
	}

	private function redrawMap()
	{
		ob.root.removeChildren();
		ob.root.addChild(ob.bg);

		populateMap();
		var white = Tile.fromColor(ColorKeys.C_WHITE_1, game.TILE_W, game.TILE_H, 0);
		var red = Tile.fromColor(ColorKeys.C_RED_1, game.TILE_W, game.TILE_H);
		var blink = new Anim([white, red], 6);

		var blinkPos = world.player.pos.toZone().toIntPoint();
		blink.x = blinkPos.x * game.TILE_W;
		blink.y = blinkPos.y * game.TILE_H;

		ob.root.addChild(blink);
	}

	override function onEnter()
	{
		var bgTile = Tile.fromColor(Game.instance.CLEAR_COLOR, world.chunkCountX * game.TILE_W, world.chunkCountY * game.TILE_H);
		ob = {
			root: new Object(),
			bg: new Bitmap(bgTile),
		};

		redrawMap();

		ob.root.visible = true;
		game.render(HUD, ob.root);
	}

	override function onResume()
	{
		ob.root.visible = true;
	}

	override function onSuspend()
	{
		ob.root.visible = false;
	}

	override function onDestroy()
	{
		ob.root.remove();
		ob.bg.remove();
	}

	override function onKeyDown(key:KeyCode)
	{
		game.input.next();
		if (key == KEY_M)
		{
			game.screens.pop();
		}
		if (key == KEY_G)
		{
			world.map.generate();
			redrawMap();
		}
	}
}
