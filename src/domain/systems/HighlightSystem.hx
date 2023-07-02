package domain.systems;

import core.Frame;
import data.TileResources;
import domain.components.Highlight;
import ecs.Entity;
import ecs.Query;
import ecs.System;
import h2d.Bitmap;
import shaders.SpriteShader;

class HighlightSystem extends System
{
	var query:Query;
	var bitmaps:Map<String, Bitmap>;

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
			var targetBm = new Bitmap(TileResources.Get(CURSOR));
			var targetPos = e.pos.toPx();
			targetBm.x = targetPos.x;
			targetBm.y = targetPos.y;
			targetBm.addShader(targetShader);
			game.render(OVERLAY, targetBm);
			bitmaps.set(e.id, targetBm);
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
