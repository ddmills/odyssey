package domain.prefabs;

import data.ColorKeys;
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

		entity.add(new SpriteAnim([CAMPFIRE_1, CAMPFIRE_2, CAMPFIRE_3], speed, ColorKeys.C_RED_1, ColorKeys.C_ORANGE_3, OBJECTS));
		entity.add(new Moniker('Campfire'));
		entity.add(new LightSource(.2, 0xe09900, 3));
		entity.add(new FuelConsumer([FUEL_WOOD], 1000, 2000, 1, true, true));
		entity.add(new Combustible(ASHES));

		return entity;
	}
}
