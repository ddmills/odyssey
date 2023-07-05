package domain.prefabs;

import data.ColorKey;
import data.TileKey;
import domain.components.LightSource;
import domain.components.SpriteAnim;
import ecs.Entity;

class ExplosionPrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var entity = new Entity();

		var frames:Array<TileKey> = [EXPLOSION_1, EXPLOSION_2, EXPLOSION_3, EXPLOSION_4, EXPLOSION_5];
		var anim = new SpriteAnim(frames, 10, ColorKey.C_RED_1, ColorKey.C_WHITE_1, FX, false);
		anim.destroyOnComplete = true;

		entity.add(anim);
		entity.add(new LightSource(.25, C_ORANGE_1, 5));

		return entity;
	}
}
