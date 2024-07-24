package domain.systems;

import core.Frame;
import core.rendering.RenderLayerManager.RenderLayerType;
import data.ColorKey;
import domain.components.Bullet;
import domain.components.IsDestroyed;
import domain.components.MoveComplete;
import domain.components.Tracer;
import ecs.Query;
import ecs.System;

class BulletSystem extends System
{
	var tracerQuery:Query;
	var fx:Map<String, h2d.Graphics>;

	public function new()
	{
		fx = new Map();

		var query = new Query({
			all: [Bullet, MoveComplete],
		});

		query.onEntityAdded((e) ->
		{
			var sound = e.get(Bullet).impactSound;
			if (sound != null)
			{
				world.playAudio(e.pos.toIntPoint(), sound);
			}
			e.add(new IsDestroyed());
		});

		tracerQuery = new Query({
			all: [Tracer]
		});

		tracerQuery.onEntityAdded((e) ->
		{
			var tracer = e.get(Tracer);
			var g = new h2d.Graphics();

			g.lineStyle(1, tracer.color, .6);

			var start = tracer.start.toPx();
			var end = tracer.end.toPx();

			g.moveTo(start.x, start.y);
			g.lineTo(end.x, end.y);
			fx.set(e.id, g);
			game.render(RenderLayerType.FX, g);
		});

		tracerQuery.onEntityRemoved((e) ->
		{
			var graphics = fx.get(e.id);

			if (graphics != null)
			{
				graphics.remove();
				fx.remove(e.id);
			}
		});
	}

	override function update(frame:Frame)
	{
		for (e in tracerQuery)
		{
			var tracer = e.get(Tracer);
			tracer.age += frame.dt;

			if (tracer.age >= .5)
			{
				e.remove(Tracer);
			}
		}
	}
}
