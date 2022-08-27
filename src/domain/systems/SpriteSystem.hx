package domain.systems;

import core.Frame;
import domain.components.Glyph;
import domain.components.Sprite;
import ecs.Entity;
import ecs.Query;
import ecs.System;
import h2d.Bitmap;
import shaders.SpriteShader;

class SpriteSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [Glyph]
		});

		query.onEntityAdded((entity) -> renderEntity(entity));
	}

	public override function update(frame:Frame) {}

	private function renderEntity(entity:Entity)
	{
		var glyph = entity.get(Glyph);
		var bm = new Bitmap(glyph.tile);
		bm.addShader(glyph.shader);
		var sprite = new Sprite(bm);
		entity.add(sprite);
		game.render(OBJECTS, bm);
	}
}
