package domain.systems;

import core.Frame;
import domain.components.IsInventoried;
import domain.components.Sprite;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class SpriteSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [Sprite],
			none: [IsInventoried]
		});

		query.onEntityAdded((entity) -> renderEntity(entity));
		query.onEntityRemoved((entity) -> hideEntity(entity));
	}

	public override function update(frame:Frame) {}

	private function renderEntity(entity:Entity)
	{
		var sprite = entity.get(Sprite);
		game.render(sprite.layer, sprite.ob);
	}

	private function hideEntity(entity:Entity)
	{
		var sprite = entity.get(Sprite);
		if (sprite != null)
		{
			sprite.ob.remove();
		}
	}
}
