package screens.cursor;

import common.util.Timeout;
import core.Frame;
import data.TileResources;
import domain.components.IsEnemy;
import domain.components.IsInventoried;
import domain.components.Moniker;
import h2d.Bitmap;
import haxe.EnumTools.EnumValueTools;
import screens.cursor.CursorScreen.CursorRenderOpts;
import shaders.SpriteShader;

class LookScreen extends CursorScreen
{
	var ob:h2d.Object;
	var lineOb:h2d.Object;
	var targetBm:h2d.Bitmap;
	var targetShader:SpriteShader;
	var targetText:h2d.Text;
	var isBlinking:Bool = false;
	var timeout:Timeout;

	var COLOR_DANGER = 0xb61111;
	var COLOR_NEUTRAL = 0xd4d4d4;
	var COLOR_SHROUD = 0x464646;

	public function new()
	{
		super();
		targetShader = new SpriteShader(COLOR_NEUTRAL);
		targetShader.isShrouded = 0;
		targetShader.clearBackground = 0;
		ob = new h2d.Object();
		lineOb = new h2d.Object(ob);
		targetBm = new Bitmap(TileResources.Get(CURSOR), ob);
		targetBm.addShader(targetShader);
		renderText();

		timeout = new Timeout(.25);
		timeout.onComplete = blink;
	}

	override function onEnter()
	{
		super.onEnter();
		game.render(OVERLAY, ob);
		game.render(HUD, targetText);
	}

	public override function onDestroy()
	{
		ob.remove();
		targetText.remove();
	}

	override function render(opts:CursorRenderOpts)
	{
		var end = opts.end.toPx();

		if (end.x == targetBm.x && end.y == targetBm.y)
		{
			return;
		}

		targetBm.x = end.x;
		targetBm.y = end.y;
		targetBm.visible = true;
		timeout.reset();
		lineOb.removeChildren();

		opts.line.each((p, idx) ->
		{
			if (idx == 0 || idx == opts.line.length - 1)
			{
				return;
			}
			var w = p.asWorld();
			var bm = new Bitmap(TileResources.Get(DOT), lineOb);
			var color = world.isVisible(w) ? COLOR_NEUTRAL : COLOR_SHROUD;
			var shader = new SpriteShader(color);
			shader.isShrouded = 0;
			bm.addShader(shader);
			var px = w.toPx();
			bm.x = px.x;
			bm.y = px.y;
		});

		var terrain = EnumValueTools.getName(world.map.getTerrain(opts.end.toIntPoint()));

		if (world.isVisible(opts.end))
		{
			targetText.text = '[$terrain]';
			var entities = world.getEntitiesAt(opts.end)
				.filter((e) -> !e.has(IsInventoried));

			isBlinking = entities.length > 0;
			if (entities.exists((e) -> e.has(IsEnemy)))
			{
				targetShader.primary = COLOR_DANGER.toHxdColor();
			}
			else
			{
				targetShader.primary = COLOR_NEUTRAL.toHxdColor();
			}

			var named = entities.find((e) -> e.has(Moniker));
			if (named != null)
			{
				var moniker = named.get(Moniker);
				targetText.text = '${moniker.displayName} [$terrain]';
			}
		}
		else
		{
			targetText.text = world.isExplored(opts.end) ? '[$terrain]' : '[UNKNOWN]';
			targetShader.primary = COLOR_SHROUD.toHxdColor();
			isBlinking = false;
		}

		targetText.x = game.window.width / 2;
		game.camera.focus = world.player.pos;
	}

	override function update(frame:Frame)
	{
		timeout.update();
		super.update(frame);
	}

	private function blink()
	{
		timeout.reset();
		targetBm.visible = isBlinking ? !targetBm.visible : true;
	}

	private function renderText()
	{
		targetText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		targetText.color = game.TEXT_COLOR.toHxdColor();
		targetText.y = 64;
		targetText.textAlign = Center;
	}
}
