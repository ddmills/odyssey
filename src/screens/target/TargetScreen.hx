package screens.target;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Frame;
import core.Screen;
import core.input.Command;
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
		game.render(OVERLAY, ob);
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
		var shader = new SpriteShader(ColorKey.C_WHITE_1);
		shader.isShrouded = 0;

		for (p in area)
		{
			var a = new Bitmap(TileResources.Get(FILLED_SQUARE), ob);
			a.alpha = .1;
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

	private function cancel()
	{
		trace('cancel target');
	}
}
