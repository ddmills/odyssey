package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import data.TileResources;
import domain.components.Highlight;
import ecs.Entity;
import ecs.Query;
import ecs.System;
import h2d.Anim;
import h2d.Object;
import shaders.SpriteShader;

typedef HighlightOb =
{
	ob:Object,
	shader:SpriteShader,
	arrow:Anim,
};

class HighlightSystem extends System
{
	var query:Query;
	var bitmaps:Map<String, HighlightOb>;

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
			var ob = new Object();
			var cursor = new Anim([
				TileResources.Get(CURSOR_SPIN_1),
				TileResources.Get(CURSOR_SPIN_2),
				TileResources.Get(CURSOR_SPIN_3),
				TileResources.Get(CURSOR_SPIN_4),
				TileResources.Get(CURSOR_SPIN_5),
			], 10);
			var arrow = new Anim([
				TileResources.Get(ARROW_BOUNCE_1),
				TileResources.Get(ARROW_BOUNCE_2),
				TileResources.Get(ARROW_BOUNCE_3),
				TileResources.Get(ARROW_BOUNCE_4),
			], 10);
			var targetPos = e.pos.toPx();
			var offsetPos = new Coordinate(0, -1, WORLD).toPx();
			arrow.x = offsetPos.x;
			arrow.y = offsetPos.y;
			arrow.visible = highlight.showArrow;
			ob.x = targetPos.x;
			ob.y = targetPos.y;
			ob.addChild(arrow);
			ob.addChild(cursor);
			cursor.addShader(targetShader);
			arrow.addShader(targetShader);
			game.render(OVERLAY, ob);
			bitmaps.set(e.id, {
				ob: ob,
				shader: targetShader,
				arrow: arrow,
			});
		});

		query.onEntityRemoved((e) ->
		{
			var bm = bitmaps.get(e.id);
			bm.ob.remove();
			bitmaps.remove(e.id);
		});
	}

	public function setEntityFilter(filter:QueryFilter)
	{
		query.setFilter(filter);
	}

	override function update(frame:Frame)
	{
		query.each((e:Entity) ->
		{
			var highlight = e.get(Highlight);
			var targetPos = e.pos.toPx();
			var bm = bitmaps.get(e.id);
			bm.ob.x = targetPos.x;
			bm.ob.y = targetPos.y;
			bm.shader.primary = highlight.color.toHxdColor();
			bm.arrow.visible = highlight.showArrow;
		});
	}
}
