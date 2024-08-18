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
import h2d.Bitmap;
import h2d.Object;
import shaders.SpriteShader;

typedef HighlightOb =
{
	ob:Object,
	shader:SpriteShader,
	arrow:Anim,
	ring:Anim,
	ringStatic:Bitmap,
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
			var shader = new SpriteShader(highlight.color);
			shader.isShrouded = 0;
			shader.clearBackground = 0;
			var ob = new Object();
			var ring = new Anim(AnimationResources.Get(CURSOR_SPIN), 12);
			var ringStatic = new Bitmap(TileResources.Get(CURSOR));
			var arrow = new Anim(AnimationResources.Get(ARROW_BOUNCE), 12);
			var targetPos = e.pos.toPx();
			var offsetPos = new Coordinate(0, -1, WORLD).toPx();
			arrow.x = offsetPos.x;
			arrow.y = offsetPos.y;
			arrow.visible = highlight.showArrow;
			ring.visible = highlight.showRing && highlight.animated;
			ringStatic.visible = highlight.showRing && !highlight.animated;
			ob.x = targetPos.x;
			ob.y = targetPos.y;
			ob.addChild(arrow);
			ob.addChild(ring);
			ob.addChild(ringStatic);
			ring.addShader(shader);
			ringStatic.addShader(shader);
			arrow.addShader(shader);
			game.render(OVERLAY, ob);
			bitmaps.set(e.id, {
				ob: ob,
				shader: shader,
				arrow: arrow,
				ring: ring,
				ringStatic: ringStatic,
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
			bm.shader.primary = highlight.color.toHxdColor().toVector();
			bm.arrow.visible = highlight.showArrow;
			bm.ring.visible = highlight.showRing && highlight.animated;
			bm.ringStatic.visible = highlight.showRing && !highlight.animated;
		});
	}
}
