package screens.map;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Frame;
import core.Game;
import core.Screen;
import core.input.KeyCode;
import data.BiomeType;
import data.Bitmasks;
import data.ColorKey;
import data.TileKey;
import data.TileResources;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Interactive;
import h2d.Object;
import h2d.Tile;
import shaders.SpriteShader;

typedef Obs =
{
	root:Object,
	bg:Bitmap,
	blink:Anim,
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

	function getIsRailroad(pos:IntPoint, lineIds:Array<Int>)
	{
		var zone = world.zones.getZone(pos);
		if (zone == null)
		{
			return false;
		}
		return (zone.railroad != null && zone.railroad.lineIds.intersects(lineIds));
	}

	function getRailroadMask(pos:IntPoint, lineIds:Array<Int>)
	{
		var n = getIsRailroad(pos.add(0, -1), lineIds) ? 2 : 0;
		var w = getIsRailroad(pos.add(-1, 0), lineIds) ? 8 : 0;
		var e = getIsRailroad(pos.add(1, 0), lineIds) ? 16 : 0;
		var s = getIsRailroad(pos.add(0, 1), lineIds) ? 64 : 0;

		return n + e + s + w;
	}

	function populateTile(pos:IntPoint)
	{
		var zone = world.zones.getZone(pos);
		var biomeKey = zone.biomes.nw;

		var tileKey = getTileKey(biomeKey);
		var tile = TileResources.Get(tileKey);
		var biome = world.map.getBiome(biomeKey);
		var primary = biome.primary;
		var secondary = biome.secondary;
		var background = biome.background;

		if (zone.biomes.river != null)
		{
			tile = TileResources.Get(OVERWORLD_RIVER);
			primary = C_BLUE_2;
			background = C_BLUE_3;
		}

		if (zone.poi != null)
		{
			tile = TileResources.Get(OVERWORLD_TOWN);
			primary = C_RED_1;
		}
		else if (zone.railroad != null)
		{
			var tileKey:TileKey = TK_UNKNOWN;
			if (zone.railroad.lineIds.length > 1)
			{
				var mask = getRailroadMask(pos, zone.railroad.lineIds);
				tileKey = Bitmasks.GetTileKey(BITMASK_RAILROAD, mask);
			}
			else
			{
				var mask = getRailroadMask(pos, [zone.railroad.lineIds[0]]);
				tileKey = Bitmasks.GetTileKey(BITMASK_RAILROAD, mask);
			}

			tile = TileResources.Get(tileKey);
			primary = C_GRAY_1;
			secondary = C_RED_2;
		}

		var bm = new Bitmap(tile);
		var shader = new SpriteShader(primary, secondary);
		shader.clearBackground = 1;
		shader.background = background.toHxdColor();
		bm.addShader(shader);

		var clicker = new Interactive(game.TILE_W, game.TILE_H, bm);
		clicker.onClick = (e) ->
		{
			teleport(pos);
		};

		bm.x = pos.x * game.TILE_W;
		bm.y = pos.y * game.TILE_H;
		ob.root.addChild(bm);
	}

	function teleport(pos:IntPoint)
	{
		trace('teleport', pos.toString());

		var targetPos = pos.asZone().add(new Coordinate(.5, .5, ZONE)).toWorld().floor();
		trace('world', targetPos.toString());

		world.player.pos = targetPos;
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

		ob.root.addChild(ob.blink);
	}

	override function onEnter()
	{
		var white = Tile.fromColor(C_YELLOW_0, game.TILE_W, game.TILE_H, 0);
		var red = Tile.fromColor(C_RED_1, game.TILE_W, game.TILE_H);
		var bgTile = Tile.fromColor(Game.instance.CLEAR_COLOR, world.chunkCountX * game.TILE_W, world.chunkCountY * game.TILE_H);
		ob = {
			root: new Object(),
			bg: new Bitmap(bgTile),
			blink: new Anim([white, red], 6),
		};

		redrawMap();

		ob.root.visible = true;
		game.render(HUD, ob.root);
	}

	override function update(frame:Frame)
	{
		var blinkPos = world.player.pos.toZone().toIntPoint();
		ob.blink.x = blinkPos.x * game.TILE_W;
		ob.blink.y = blinkPos.y * game.TILE_H;
		world.updateSystems();
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
