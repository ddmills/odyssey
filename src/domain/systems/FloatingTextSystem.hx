package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import data.ColorKey;
import data.TextResources;
import domain.components.FloatingText;
import domain.components.Health;
import ecs.Query;
import ecs.System;
import h2d.Object;
import h2d.Text;

typedef FloatingTextOb =
{
	ob:Object,
	text:Text,
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
			text.scale(.6);
			text.visible = true;
			text.dropShadow = {
				dx: .8,
				dy: .8,
				color: 0x000000,
				alpha: .75
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
			floater.ob.y -= component.speed * frame.tmod;
			component.lifetime -= frame.tmod;

			if (component.lifetime <= 0)
			{
				e.destroy();
			}
		}
	}
}
