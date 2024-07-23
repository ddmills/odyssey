package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import data.AnimationResources;
import data.ColorKey;
import domain.components.Health;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.components.Visible;
import ecs.Query;
import ecs.System;
import h2d.Anim;
import h2d.Object;
import shaders.SpriteShader;

typedef HealthBarOb =
{
	ob:Object,
	shader:SpriteShader,
	bar:Anim,
	prevValue:Float,
};

class HealthBarSystem extends System
{
	var query:Query;
	var bars:Map<String, HealthBarOb>;

	public function new()
	{
		bars = new Map();
		query = new Query({
			all: [Health, Visible],
			none: [IsDestroyed, IsInventoried],
		});

		query.onEntityAdded((e) ->
		{
			var ob = new Object();
			var bar = new Anim(AnimationResources.Get(PROGRESS_BAR), 0, ob);
			var shader = new SpriteShader(ColorKey.C_RED_1, ColorKey.C_GRAY_5);
			shader.isShrouded = 0;
			bar.addShader(shader);
			var offsetPos = new Coordinate(0, -1, WORLD).toPx();
			bar.x = offsetPos.x;
			bar.y = offsetPos.y;
			game.render(OVERLAY, ob);
			bars.set(e.id, {
				ob: ob,
				shader: shader,
				bar: bar,
				prevValue: 0,
			});
		});

		query.onEntityRemoved((e) ->
		{
			var bm = bars.get(e.id);
			bm.ob.remove();
			bars.remove(e.id);
		});
	}

	override function update(frame:Frame)
	{
		for (e in query)
		{
			var health = e.get(Health);
			var targetPos = e.pos.toPx();
			var bm = bars.get(e.id);
			bm.bar.currentFrame = (health.percent * (bm.bar.frames.length - 1));
			bm.ob.x = targetPos.x;
			bm.ob.y = targetPos.y;

			if (bm.prevValue > health.value)
			{
				bm.shader.primary = C_YELLOW_1.toHxdColor().toVector();
			}
			else
			{
				bm.shader.primary = C_RED_1.toHxdColor().toVector();
			}

			bm.prevValue = health.value;
		}
	}
}
