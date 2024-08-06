package screens.cursor;

import common.algorithm.Bresenham;
import core.Frame;
import data.AnimationResources;
import data.ColorKey;
import data.TileResources;
import domain.components.IsEnemy;
import domain.components.IsInventoried;
import domain.components.Moniker;
import h2d.Anim;
import h2d.Bitmap;
import screens.cursor.CursorScreen.CursorRenderOpts;
import shaders.SpriteShader;

class LookScreen extends CursorScreen
{
	var ob:h2d.Object;
	var lineOb:h2d.Object;
	var targetBm:Anim;
	var targetShader:SpriteShader;
	var targetText:h2d.Text;

	public function new()
	{
		super();
		targetShader = new SpriteShader(ColorKey.C_YELLOW);
		targetShader.isShrouded = 0;
		targetShader.clearBackground = 0;
		ob = new h2d.Object();
		lineOb = new h2d.Object(ob);
		targetBm = new Anim(AnimationResources.Get(CURSOR_SPIN), 10, ob);
		targetBm.addShader(targetShader);
		renderText();
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
		lineOb.removeChildren();

		opts.line.each((p, idx) ->
		{
			if (idx == 0 || idx == opts.line.length - 1)
			{
				return;
			}
			var w = p.asWorld();
			var bm = new Bitmap(TileResources.Get(DOT), lineOb);
			var color = world.isVisible(w) ? ColorKey.C_YELLOW : ColorKey.C_LIGHT_GRAY;
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

			if (entities.exists((e) -> e.has(IsEnemy)))
			{
				targetShader.primary = ColorKey.C_RED.toHxdColor().toVector();
			}
			else
			{
				targetShader.primary = game.TEXT_COLOR_FOCUS.toHxdColor().toVector();
			}

			var names = entities.filter((e) -> e.has(Moniker)).map((e) ->
			{
				var name = e.get(Moniker).displayName;
				var relation = world.factions.getEntityRelation(e, world.player.entity);
				var disp = world.factions.getDisplay(relation, true);
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
			targetShader.primary = ColorKey.C_LIGHT_GRAY.toHxdColor().toVector();
		}

		targetText.x = game.window.width / 2;
		game.camera.focus = world.player.pos;
	}

	override function update(frame:Frame)
	{
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

	private function renderText()
	{
		targetText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		targetText.color = game.TEXT_COLOR.toHxdColor();
		targetText.y = 64;
		targetText.textAlign = Center;
	}
}
