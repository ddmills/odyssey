package domain.prefabs;

import domain.components.Moniker;
import domain.components.SpriteAnim;
import ecs.Entity;
import hxd.Rand;

class CampfirePrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var entity = new Entity();

		var speed = (Rand.create().rand() * 3) + 3;

		// entity.add(new Sprite(CAMPFIRE_1, 0x8D450B, 0xF3A52F, OBJECTS));
		entity.add(new SpriteAnim([CAMPFIRE_1, CAMPFIRE_2, CAMPFIRE_3], speed, 0x8D450B, 0xF3A52F, OBJECTS));
		entity.add(new Moniker('Campfire'));

		return entity;
	}
}
