package domain.systems;

import domain.components.Bullet;
import domain.components.MoveComplete;
import ecs.Query;
import ecs.System;

class BulletSystem extends System
{
	public function new()
	{
		var query = new Query({
			all: [Bullet, MoveComplete],
		});

		query.onEntityAdded((e) ->
		{
			var sound = e.get(Bullet).impactSound;
			if (sound != null)
			{
				game.sound.play(sound);
			}
			e.destroy();
		});
	}
}
