package domain.systems;

import core.Frame;
import data.TileResources;
import domain.components.Highlight;
import ecs.Entity;
import ecs.Query;
import ecs.System;
import h2d.Anim;
import shaders.SpriteShader;

class HighlightSystem extends System
{
	var query:Query;
	var bitmaps:Map<String, Anim>;

	public function new()
	{
		bitmaps = new Map();

		query = new Query({
			all: [Highlight],
		});

		query.onEntityAdded((e) ->
		{
			var highlight = e.get(Highlight);
			var targetShader = new SpriteShader(highlight.color);
			targetShader.isShrouded = 0;
			targetShader.clearBackground = 0;
			var anim = new Anim([
				TileResources.Get(CURSOR_SPIN_1),
				TileResources.Get(CURSOR_SPIN_2),
				TileResources.Get(CURSOR_SPIN_3),
				TileResources.Get(CURSOR_SPIN_4),
				TileResources.Get(CURSOR_SPIN_5),
			], 10);
			var targetPos = e.pos.toPx();
			anim.x = targetPos.x;
			anim.y = targetPos.y;
			anim.addShader(targetShader);
			game.render(OVERLAY, anim);
			bitmaps.set(e.id, anim);
		});

		query.onEntityRemoved((e) ->
		{
			var bm = bitmaps.get(e.id);
			bm.remove();
			bitmaps.remove(e.id);
		});
	}

	public function setEntityFilter(filter:QueryFilter)
	{
		query.setFilter(filter);
	}

	override function update(frame:Frame)
	{
		query.each((entity:Entity) ->
		{
			var h = entity.get(Highlight);
			var targetPos = entity.pos.toPx();
			var bm = bitmaps.get(entity.id);
			bm.x = targetPos.x;
			bm.y = targetPos.y;
		});
	}
}
