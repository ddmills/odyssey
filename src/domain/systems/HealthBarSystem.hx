package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import data.AnimationResources;
import data.ColorKey;
import domain.components.Health;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.components.Visible;
import ecs.Query;
import ecs.System;
import h2d.Anim;
import h2d.Object;
import shaders.SpriteShader;

typedef HealthBarOb =
{
	ob:Object,
	shader:SpriteShader,
	barHealth:Anim,
	barArmor:Anim,
	prevValue:Float,
};

class HealthBarSystem extends System
{
	var query:Query;
	var bars:Map<String, HealthBarOb>;

	public function new()
	{
		bars = new Map();
		query = new Query({
			all: [Health, Visible],
			none: [IsDestroyed, IsInventoried],
		});

		query.onEntityAdded((e) ->
		{
			var ob = new Object();
			var bar = new Anim(AnimationResources.Get(PROGRESS_BAR), 0, ob);
			var barArmor = new Anim(AnimationResources.Get(PROGRESS_BAR), 0, ob);

			var shader = new SpriteShader(ColorKey.C_RED_1, ColorKey.C_GRAY_5);
			shader.isShrouded = 0;
			bar.addShader(shader);

			var barArmorShader = new SpriteShader(ColorKey.C_BLUE_1, ColorKey.C_GRAY_5);
			barArmorShader.isShrouded = 0;
			barArmor.addShader(barArmorShader);

			var offsetPos = new Coordinate(0, -1, WORLD).toPx();
			bar.x = offsetPos.x;
			bar.y = offsetPos.y;

			var armorOffsetPos = new Coordinate(0, -1.2, WORLD).toPx();
			barArmor.x = armorOffsetPos.x;
			barArmor.y = armorOffsetPos.y;

			game.render(OVERLAY, ob);
			bars.set(e.id, {
				ob: ob,
				shader: shader,
				barHealth: bar,
				barArmor: barArmor,
				prevValue: 0,
			});
		});

		query.onEntityRemoved((e) ->
		{
			var bm = bars.get(e.id);
			bm.ob.remove();
			bars.remove(e.id);
		});
	}

	override function update(frame:Frame)
	{
		for (e in query)
		{
			var health = e.get(Health);
			var targetPos = e.drawable.getDrawnPosition().toPx();
			var bm = bars.get(e.id);
			bm.ob.x = targetPos.x;
			bm.ob.y = targetPos.y;

			bm.barArmor.currentFrame = (health.armorPercent * (bm.barHealth.frames.length - 1));
			// bm.shader.primary = C_BLUE_1.toHxdColor().toVector();
			// bm.shader.secondary = C_GRAY_5.toHxdColor().toVector();

			bm.barHealth.currentFrame = (health.percent * (bm.barHealth.frames.length - 1));
			bm.shader.primary = C_RED_1.toHxdColor().toVector();
			bm.shader.secondary = C_GRAY_5.toHxdColor().toVector();

			bm.prevValue = health.value;
		}
	}
}
