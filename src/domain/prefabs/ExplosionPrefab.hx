package domain.prefabs;

import data.ColorKey;
import domain.components.LightSource;
import domain.components.SpriteAnim;
import ecs.Entity;

class ExplosionPrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var entity = new Entity();

		var anim = new SpriteAnim(EXPLOSION, 10, ColorKey.C_RED_1, ColorKey.C_WHITE_1, FX, false);
		anim.destroyOnComplete = true;

		entity.add(anim);
		entity.add(new LightSource(.25, C_ORANGE_1, 8));

		return entity;
	}
}
