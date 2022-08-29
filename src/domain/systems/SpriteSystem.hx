package domain.systems;

import core.Frame;
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
			all: [Sprite]
		});

		query.onEntityAdded((entity) -> renderEntity(entity));
	}

	public override function update(frame:Frame) {}

	private function renderEntity(entity:Entity)
	{
		var sprite = entity.get(Sprite);
		game.render(sprite.layer, sprite.ob);
	}
}
