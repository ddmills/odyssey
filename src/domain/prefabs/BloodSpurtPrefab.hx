package domain.prefabs;

import data.ColorKey;
import domain.components.SpriteAnim;
import ecs.Entity;

class BloodSpurtPrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var entity = new Entity();

		var anim = new SpriteAnim(LIQUID_SPURT, 10, ColorKey.C_RED_1, ColorKey.C_RED_2, FX, false);
		anim.destroyOnComplete = true;

		entity.add(anim);

		return entity;
	}
}
