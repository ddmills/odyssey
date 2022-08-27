package domain.systems;

import core.Frame;
import data.TileResources;
import domain.components.Glyph;
import domain.components.Sprite;
import ecs.Entity;
import ecs.Query;
import ecs.System;
import h2d.Bitmap;
import h2d.Tile;

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
		var sprite = new Sprite(bm);
		entity.add(sprite);
		game.render(OBJECTS, bm);
	}
}
