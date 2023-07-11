package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import data.AnimationResources;
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
	ring:Anim,
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
			var ring = new Anim(AnimationResources.Get(CURSOR_SPIN), 10);
			var arrow = new Anim(AnimationResources.Get(ARROW_BOUNCE), 10);
			var targetPos = e.pos.toPx();
			var offsetPos = new Coordinate(0, -1, WORLD).toPx();
			arrow.x = offsetPos.x;
			arrow.y = offsetPos.y;
			arrow.visible = highlight.showArrow;
			ring.visible = highlight.showRing;
			ob.x = targetPos.x;
			ob.y = targetPos.y;
			ob.addChild(arrow);
			ob.addChild(ring);
			ring.addShader(targetShader);
			arrow.addShader(targetShader);
			game.render(OVERLAY, ob);
			bitmaps.set(e.id, {
				ob: ob,
				shader: targetShader,
				arrow: arrow,
				ring: ring,
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
			bm.ring.visible = highlight.showRing;
		});
	}
}
