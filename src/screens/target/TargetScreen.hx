package screens.target;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import data.ColorKey;
import data.TileResources;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Object;
import screens.target.footprints.Footprint;
import shaders.SpriteShader;

enum TargetSource
{
	CURSOR;
	TARGETER;
}

typedef TargetResult =
{
	pos:Coordinate,
}

typedef TargetSettings =
{
	onSelect:(result:TargetResult) -> Void,
	source:TargetSource,
	footprint:Footprint,
}

class TargetScreen extends Screen
{
	var targeter:Entity;
	var settings:TargetSettings;
	var source:Coordinate;
	var ob:Object;

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
		if (settings.source == TARGETER)
		{
			source = targeter.pos.floor();
		}
		else if (settings.source == CURSOR)
		{
			source = game.input.mouse.toWorld().floor();
		}

		ob.removeChildren();

		var sourcePx = targeter.pos.toPx();
		ob.x = sourcePx.x;
		ob.y = sourcePx.y;

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
	}
}
