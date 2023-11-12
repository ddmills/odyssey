package screens.target;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Frame;
import core.Screen;
import data.Bitmasks;
import data.ColorKey;
import data.TileResources;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Object;
import screens.target.footprints.Footprint;
import shaders.SpriteShader;

enum TargetOrigin
{
	CURSOR;
	TARGETER;
}

typedef TargetResult =
{
	area:Array<IntPoint>,
	origin:IntPoint,
	cursor:IntPoint,
}

typedef TargetSettings =
{
	origin:TargetOrigin,
	footprint:Footprint,
}

class TargetScreen extends Screen
{
	var targeter:Entity;
	var settings:TargetSettings;
	var origin:Coordinate;
	var ob:Object;
	var result:TargetResult;

	public function new(targeter:Entity, settings:TargetSettings)
	{
		this.targeter = targeter;
		this.settings = settings;

		inputDomain = INPUT_DOMAIN_ADVENTURE;
		ob = new Object();
	}

	override function onEnter()
	{
		game.render(GROUND, ob);
	}

	override function onDestroy()
	{
		ob.remove();
	}

	override function update(frame:Frame)
	{
		world.updateSystems();

		var mouse = game.input.mouse.toWorld().floor();
		if (settings.origin == TARGETER)
		{
			origin = targeter.pos.floor();
		}
		else if (settings.origin == CURSOR)
		{
			origin = game.input.mouse.toWorld().floor();
		}

		ob.removeChildren();

		var originPx = targeter.pos.toPx();
		ob.x = originPx.x;
		ob.y = originPx.y;

		var area = settings.footprint.getFootprint(targeter.pos, mouse);
		var shader = new SpriteShader(C_RED_3, C_GRAY_1);
		shader.isShrouded = 0;

		for (p in area)
		{
			var mask = Bitmasks.SumMask((x, y) ->
			{
				var local = p.add(x, y);
				return area.exists((point) -> point.equals(local));
			});

			var tileKey = Bitmasks.GetTileKey(BITMASK_HIGHLIGHT, mask);
			var a = new Bitmap(TileResources.Get(tileKey), ob);
			a.alpha = .6;
			a.addShader(shader);

			var pos = p.asWorld().sub(targeter.pos).toPx();

			a.x = pos.x;
			a.y = pos.y;
		}

		result = {
			area: area,
			origin: targeter.pos.toIntPoint(),
			cursor: mouse.toIntPoint(),
		};
	}
}
