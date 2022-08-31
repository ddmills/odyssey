package screens.cursor.renderer;

import common.struct.Coordinate;
import common.util.Timeout;
import core.Frame;
import core.Game;
import data.TileResources;
import domain.components.IsEnemy;
import domain.components.Moniker;
import h2d.Bitmap;
import haxe.EnumTools.EnumValueTools;
import screens.cursor.CursorScreen.CursorRenderOpts;
import shaders.SpriteShader;

class LookCursorRenderer extends CursorRenderer
{
	var ob:h2d.Object;
	var targetBm:h2d.Bitmap;
	var targetShader:SpriteShader;
	var targetText:h2d.Text;
	var isBlinking:Bool = false;
	var timeout:Timeout;

	var COLOR_DANGER = 0xb61111;
	var COLOR_NEUTRAL = 0xa2bdc2;

	public function new()
	{
		targetShader = new SpriteShader(COLOR_NEUTRAL);
		targetShader.isShrouded = 0;
		targetShader.clearBackground = 1;
		ob = new h2d.Object();
		targetBm = new Bitmap(TileResources.EYE_OPEN, ob);
		targetBm.addShader(targetShader);
		renderText();
		game.render(OVERLAY, ob);
		game.render(HUD, targetText);
		timeout = new Timeout(.5);
		timeout.onComplete = blink;
	}

	private function blink()
	{
		timeout.reset();
		targetBm.visible = isBlinking ? !targetBm.visible : true;
	}

	public override function update(frame:Frame)
	{
		timeout.update();
	}

	public override function cleanup()
	{
		ob.remove();
		targetText.remove();
	}

	public override function render(opts:CursorRenderOpts)
	{
		var end = opts.end.toPx();

		if (end.x != targetBm.x || end.y != targetBm.y)
		{
			targetBm.x = end.x;
			targetBm.y = end.y;
			targetBm.visible = true;
			timeout.reset();
		}

		targetShader.primary = COLOR_NEUTRAL.toHxdColor();

		var terrain = EnumValueTools.getName(world.map.getTerrain(opts.end.x, opts.end.y));

		if (world.isVisible(opts.end))
		{
			targetText.text = '[$terrain]';
			targetBm.tile = TileResources.EYE_OPEN;
			var entities = world.getEntitiesAt(opts.end);
			isBlinking = entities.length > 0;
			if (entities.exists((e) -> e.has(IsEnemy)))
			{
				targetShader.primary = COLOR_DANGER.toHxdColor();
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
			if (world.isExplored(opts.end))
			{
				targetText.text = '[$terrain]';
			}
			else
			{
				targetText.text = '[UNKNOWN]';
			}
			targetBm.tile = TileResources.EYE_CLOSE;
			isBlinking = false;
		}

		targetText.x = game.window.width / 2;
		game.camera.focus = world.player.pos;
	}

	private function renderText()
	{
		targetText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		targetText.color = new h3d.Vector(1, 1, .9);
		targetText.y = 64;
		targetText.textAlign = Center;
	}
}
