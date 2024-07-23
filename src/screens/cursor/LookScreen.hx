package screens.cursor;

import common.algorithm.Bresenham;
import common.util.Timeout;
import core.Frame;
import data.ColorKey;
import data.TileResources;
import domain.components.IsEnemy;
import domain.components.IsInventoried;
import domain.components.Moniker;
import h2d.Bitmap;
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

	public function new()
	{
		super();
		targetShader = new SpriteShader(ColorKey.C_YELLOW_0);
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
			var color = world.isVisible(w) ? ColorKey.C_YELLOW_0 : ColorKey.C_GRAY_1;
			var shader = new SpriteShader(color);
			shader.isShrouded = 0;
			bm.addShader(shader);
			var px = w.toPx();
			bm.x = px.x;
			bm.y = px.y;
		});

		if (world.isVisible(opts.end))
		{
			var entities = world.getEntitiesAt(opts.end)
				.filter((e) -> !e.has(IsInventoried));

			isBlinking = entities.length > 0;
			if (entities.exists((e) -> e.has(IsEnemy)))
			{
				targetShader.primary = ColorKey.C_RED_1.toHxdColor().toVector();
			}
			else
			{
				targetShader.primary = game.TEXT_COLOR_FOCUS.toHxdColor().toVector();
			}

			var names = entities.filter((e) -> e.has(Moniker)).map((e) ->
			{
				var name = e.get(Moniker).displayName;
				var relation = world.factions.getEntityRelation(e, world.player.entity);
				var disp = world.factions.getDisplay(relation);
				return '$name [$disp]';
			});

			if (names.length > 0)
			{
				targetText.text = names.join(', ');
			}
		}
		else
		{
			targetText.text = '';
			targetShader.primary = ColorKey.C_GRAY_1.toHxdColor().toVector();
			isBlinking = false;
		}

		targetText.x = game.window.width / 2;
		game.camera.focus = world.player.pos;
	}

	override function update(frame:Frame)
	{
		timeout.update();
		render({
			start: start,
			end: target,
			line: Bresenham.getLine(start.toIntPoint(), target.toIntPoint()),
		});
		world.updateSystems();
		if (world.systems.energy.isPlayersTurn)
		{
			var cmd = game.commands.peek();
			if (cmd != null)
			{
				handleInput(game.commands.next());
			}
		}
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
