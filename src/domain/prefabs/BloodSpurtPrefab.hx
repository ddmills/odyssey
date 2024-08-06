package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.SpriteAnim;
import ecs.Entity;

class BloodSpurtPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);

		var anim = new SpriteAnim(LIQUID_SPURT, 10, ColorKey.C_RED, ColorKey.C_RED, FX, false);
		anim.destroyOnComplete = true;

		entity.add(anim);

		return entity;
	}
}
