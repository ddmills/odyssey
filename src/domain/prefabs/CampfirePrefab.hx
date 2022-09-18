package domain.prefabs;

import domain.components.LightSource;
import domain.components.Moniker;
import domain.components.SpriteAnim;
import ecs.Entity;
import hxd.Rand;

class CampfirePrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var entity = new Entity();
		var r = Rand.create();

		var speed = (r.rand() * 3) + 3;

		entity.add(new SpriteAnim([CAMPFIRE_1, CAMPFIRE_2, CAMPFIRE_3], speed, 0x8D450B, 0xF3A52F, OBJECTS));
		entity.add(new Moniker('Campfire'));
		entity.add(new LightSource(.5, 0xe47e1e, 5));

		return entity;
	}
}
