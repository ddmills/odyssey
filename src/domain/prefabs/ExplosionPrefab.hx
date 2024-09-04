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

		var anim = new SpriteAnim(EXPLOSION, 10, ColorKey.C_RED, ColorKey.C_WHITE, FX, false);
		anim.destroyOnComplete = true;

		entity.add(anim);
		entity.add(new LightSource(1, C_YELLOW, 4));

		return entity;
	}
}
