package domain.systems;

import core.Frame;
import core.Game;
import domain.components.HitBlink;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
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
			none: [IsInventoried, IsDestroyed],
		});

		query.onEntityAdded((e) ->
		{
			e.get(Sprite).outlineOverride = 0xeeeeee;
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
			var blink = entity.get(HitBlink);
			blink.time += frame.dt;
			if (blink.time > .05)
			{
				entity.remove(HitBlink);
			}
		});
	}
}
