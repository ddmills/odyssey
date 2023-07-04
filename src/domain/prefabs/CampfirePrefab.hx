package domain.prefabs;

import data.ColorKey;
import domain.components.Combustible;
import domain.components.FuelConsumer;
import domain.components.LightSource;
import domain.components.Moniker;
import domain.components.SpriteAnim;
import ecs.Entity;
import hxd.Rand;

class CampfirePrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();
		var r = Rand.create();

		var speed = (r.rand() * 3) + 3;

		entity.add(new SpriteAnim([CAMPFIRE_1, CAMPFIRE_2, CAMPFIRE_3], speed, C_ORANGE_2, C_YELLOW_1, OBJECTS));
		entity.add(new Moniker('Campfire'));
		entity.add(new LightSource(.85, C_YELLOW_2, 4));
		entity.add(new FuelConsumer([FUEL_WOOD], 5000, 5000, 1, true, true));
		entity.add(new Combustible(ASHES));

		return entity;
	}
}
