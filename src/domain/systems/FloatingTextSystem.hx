package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import data.TextResources;
import domain.components.FloatingText;
import ecs.Query;
import ecs.System;
import h2d.Object;
import h2d.Text;

typedef FloatingTextOb =
{
	ob:Object,
	text:Text,
	start:Coordinate,
};

class FloatingTextSystem extends System
{
	var query:Query;
	var floaters:Map<String, FloatingTextOb>;

	public function new()
	{
		floaters = new Map();
		query = new Query({
			all: [FloatingText],
		});

		query.onEntityAdded((e) ->
		{
			trace('added', e.pos.toWorld().toString());
			var floater = e.get(FloatingText);
			var ob = new Object();

			var text = new Text(TextResources.BIZCAT, ob);
			text.color = floater.color.toHxdColor();
			text.text = floater.text;
			text.textAlign = Center;
			text.scale(1);
			text.dropShadow = {
				dx: 1,
				dy: 1,
				color: 0x1c1c1c,
				alpha: 1
			};

			var offsetPos = new Coordinate(.5, -1, WORLD).toPx();
			text.x = offsetPos.x;
			text.y = offsetPos.y;

			game.render(OVERLAY, ob);
			var targetPos = e.pos.toPx();
			ob.x = targetPos.x;
			ob.y = targetPos.y;
			floaters.set(e.id, {
				ob: ob,
				text: text,
				start: targetPos,
			});
		});

		query.onEntityRemoved((e) ->
		{
			var bm = floaters.get(e.id);
			bm.ob.remove();
			floaters.remove(e.id);
		});
	}

	override function update(frame:Frame)
	{
		for (e in query)
		{
			var component = e.get(FloatingText);
			var floater = floaters.get(e.id);
			var life = (component.lifetime / component.duration);

			var target = floater.start.y - 8;

			floater.ob.y = floater.start.y.lerp(target, (life).ease(EASE_OUT_QUINT));
			floater.ob.alpha = (1 - life).ease(EASE_OUT_QUINT);

			var scale = .4.lerp(1, life.ease(EASE_OUT_QUINT));
			floater.text.setScale(scale);

			component.lifetime += frame.tmod;
			if (life > 1)
			{
				e.destroy();
			}
		}
	}
}
