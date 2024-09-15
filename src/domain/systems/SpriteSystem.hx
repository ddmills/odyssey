package domain.systems;

import common.util.Colors;
import core.Frame;
import data.ColorKey;
import domain.components.Drawable;
import domain.components.IsDestroyed;
import domain.components.IsDetached;
import domain.components.IsInventoried;
import domain.components.Sprite;
import domain.components.SpriteAnim;
import domain.terrain.biomes.Biomes;
import ecs.Query;
import ecs.System;

class SpriteSystem extends System
{
	var sprites:Query;
	var anims:Query;
	var currentBiomeColor:Null<Int>;
	var targetBiomeColor:Null<Int>;
	var biomeColorLerpStartTick:Int;
	var biomeColorLerpDuration:Int = 2500;
	var nightColor:Int = 0x0F090F;

	public function new()
	{
		sprites = new Query({
			all: [Sprite],
			none: [IsDetached, IsInventoried, IsDestroyed]
		});
		anims = new Query({
			all: [SpriteAnim],
			none: [IsDetached, IsInventoried, IsDestroyed]
		});

		sprites.onEntityAdded((entity) -> renderSprite(entity.get(Sprite)));
		sprites.onEntityRemoved((entity) -> removeSprite(entity.get(Sprite)));

		anims.onEntityAdded((entity) -> renderSprite(entity.get(SpriteAnim)));
		anims.onEntityRemoved((entity) -> removeSprite(entity.get(SpriteAnim)));
		game.app.s2d.renderer.globals.set("daylight", world.clock.getDaylight());
		game.app.s2d.renderer.globals.set("dayProgress", world.clock.progress);
	}

	public override function update(frame:Frame)
	{
		if (world.clock.tickDelta > 0)
		{
			var daylight = world.clock.getDaylight();
			// TODO: REALMS have based on underground biome
			game.app.s2d.renderer.globals.set("daylight", daylight);
			game.app.s2d.renderer.globals.set("dayProgress", world.clock.progress);

			var biome = Biomes.get(world.getCurrentBiomeType());

			if (currentBiomeColor == null)
			{
				currentBiomeColor = biome.clearColor;
			}

			if (biome.clearColor != targetBiomeColor)
			{
				biomeColorLerpStartTick = world.clock.tick;
			}

			targetBiomeColor = biome.clearColor;

			var progress = (world.clock.tick - biomeColorLerpStartTick) / biomeColorLerpDuration;

			if (progress < 1)
			{
				currentBiomeColor = Colors.Mix(currentBiomeColor, targetBiomeColor, progress);
			}
			else
			{
				currentBiomeColor = targetBiomeColor;
			}

			var c = Colors.Mix(nightColor, currentBiomeColor, daylight);
			var clear = c.toHxdColor().toVector();

			game.app.s2d.renderer.globals.set("clearColor", clear);
			game.layers.bkgBm.color = clear.toVector4();
		}
	}

	private function renderSprite(drawable:Drawable)
	{
		if (drawable != null)
		{
			game.render(drawable.layer, drawable.drawable);
		}
	}

	private function removeSprite(drawable:Drawable)
	{
		if (drawable != null)
		{
			drawable.drawable.remove();
		}
	}
}
