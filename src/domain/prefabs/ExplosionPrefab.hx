package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.LightSource;
import domain.components.SpriteAnim;
import ecs.Entity;

class ExplosionPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var entity = new Entity(pos);

		var anim = new SpriteAnim(EXPLOSION, 10, ColorKey.C_RED_1, ColorKey.C_WHITE, FX, false);
		anim.destroyOnComplete = true;

		entity.add(anim);
		entity.add(new LightSource(.25, C_RED_1, 8));

		return entity;
	}
}
