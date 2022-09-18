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

		// var lightColor = r.pick([0xf0c465, 0xd343ff, 0x65ff51, 0x1e87ff, 0x8577ff]);

		entity.add(new SpriteAnim([CAMPFIRE_1, CAMPFIRE_2, CAMPFIRE_3], speed, 0x8D450B, 0xF3A52F, OBJECTS));
		entity.add(new Moniker('Campfire'));
		entity.add(new LightSource(.5, 0xf0c465, 6));

		return entity;
	}
}
