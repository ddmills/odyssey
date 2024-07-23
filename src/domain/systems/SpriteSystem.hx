package domain.systems;

import core.Frame;
import domain.components.Drawable;
import domain.components.IsDestroyed;
import domain.components.IsDetached;
import domain.components.IsInventoried;
import domain.components.Sprite;
import domain.components.SpriteAnim;
import ecs.Query;
import ecs.System;

class SpriteSystem extends System
{
	var sprites:Query;
	var anims:Query;

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
		game.app.s2d.renderer.globals.set("dayProgress", world.clock.getDaylight());
	}

	public override function update(frame:Frame)
	{
		if (world.clock.tickDelta > 0)
		{
			game.app.s2d.renderer.globals.set("dayProgress", world.clock.getDaylight());
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
