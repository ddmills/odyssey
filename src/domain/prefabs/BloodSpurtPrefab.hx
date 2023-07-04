package domain.prefabs;

import data.ColorKey;
import data.TileKey;
import domain.components.SpriteAnim;
import ecs.Entity;

class BloodSpurtPrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var entity = new Entity();

		var frames:Array<TileKey> = [LIQUID_SPURT_1, LIQUID_SPURT_2, LIQUID_SPURT_3, LIQUID_SPURT_4, LIQUID_SPURT_5];
		var anim = new SpriteAnim(frames, 10, ColorKey.C_RED_1, ColorKey.C_RED_2, FX, false);
		anim.destroyOnComplete = true;

		entity.add(anim);

		return entity;
	}
}
