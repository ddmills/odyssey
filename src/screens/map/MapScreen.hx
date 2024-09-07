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
import domain.components.Move;
import domain.events.ConsumeEnergyEvent;
import domain.terrain.biomes.Biomes;
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
	var scale = 1;

	public function new() {}

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

		var biome = Biomes.get(biomeKey);
		var icon = biome.getMapIcon();
		var tileKey = icon.tileKey;
		var tile = TileResources.Get(tileKey);
		var primary = icon.primary;
		var secondary = icon.secondary;
		var background = biome.clearColor;

		if (zone.biomes.river.nw)
		{
			tile = TileResources.Get(OVERWORLD_WATER_1);
			primary = C_BLUE;
			background = C_DARK_BLUE;
		}

		if (zone.poi != null)
		{
			tile = TileResources.Get(OVERWORLD_TOWN);

			var poiIcon = zone.poi.definition.icon;

			tileKey = poiIcon.tileKey;
			tile = TileResources.Get(tileKey);
			primary = poiIcon.primary;
			secondary = poiIcon.secondary;
			// background = poiIcon.background;
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
			primary = C_LIGHT_GRAY;
			secondary = C_RED;
		}

		var bm = new Bitmap(tile);
		bm.width = game.TILE_W * scale;
		bm.height = game.TILE_W * scale;
		var shader = new SpriteShader(primary, secondary);
		shader.background = background.toHxdColor().toVector();
		shader.clearBackground = 1;
		shader.ignoreLighting = 1;
		bm.addShader(shader);

		var clicker = new Interactive(game.TILE_W * scale, game.TILE_W * scale, bm);
		clicker.onClick = (e) ->
		{
			teleport(pos);
		};

		bm.x = pos.x * game.TILE_W * scale;
		bm.y = pos.y * game.TILE_W * scale;
		ob.root.addChild(bm);
	}

	function teleport(pos:IntPoint)
	{
		var targetPos = pos.asZone().add(new Coordinate(.5, .5, ZONE)).toWorld().floor();
		trace('teleport', pos.toString(), targetPos.toString());

		world.player.entity.remove(Move);
		world.chunks.loadChunks(targetPos.toChunkIdx());
		world.chunks.loadChunk(targetPos.toChunkIdx());
		world.player.entity.drawable.pos = null;
		world.player.pos = targetPos;
		world.player.entity.fireEvent(new ConsumeEnergyEvent(1));
		game.camera.focus = targetPos;
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
		var white = Tile.fromColor(C_YELLOW, game.TILE_W * scale, game.TILE_W * scale, 0);
		var red = Tile.fromColor(C_RED, game.TILE_W * scale, game.TILE_W * scale);
		var bgTile = Tile.fromColor(Game.instance.CLEAR_COLOR, world.chunkCountX * game.TILE_W, world.chunkCountY * game.TILE_W);
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
		ob.blink.x = blinkPos.x * game.TILE_W * scale;
		ob.blink.y = blinkPos.y * game.TILE_W * scale;
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
