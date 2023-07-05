package domain.systems;

import core.Frame;
import core.Game;
import domain.components.HitBlink;
import domain.components.IsDestroyed;
import domain.components.Sprite;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class HitBlinkSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [HitBlink, Sprite],
			none: [IsDestroyed],
		});

		query.onEntityAdded((e) ->
		{
			e.get(Sprite).outlineOverride = e.get(HitBlink).color;
		});

		query.onEntityRemoved((e) ->
		{
			if (e.has(Sprite))
			{
				e.get(Sprite).outlineOverride = Game.instance.CLEAR_COLOR;
			}
		});
	}

	override function update(frame:Frame)
	{
		query.each((entity:Entity) ->
		{
			var sprite = entity.get(Sprite);
			var blink = entity.get(HitBlink);
			blink.timeSeconds += frame.dt;

			if ((blink.timeSeconds / blink.rateSeconds).floor() % 2 == 0)
			{
				sprite.outlineOverride = blink.color;
			}
			else
			{
				sprite.outlineOverride = blink.originalColor;
			}

			if (blink.timeSeconds > blink.durationSeconds)
			{
				sprite.outlineOverride = blink.originalColor;
				entity.remove(HitBlink);
			}
		});
	}
}
