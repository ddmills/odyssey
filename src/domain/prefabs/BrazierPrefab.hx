package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Collider;
import domain.components.Destructable;
import domain.components.FuelConsumer;
import domain.components.LightSource;
import domain.components.Moniker;
import domain.components.SpriteAnim;
import ecs.Entity;
import hxd.Rand;

class BrazierPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);
		var r = Rand.create();

		var speed = (r.rand() * 3) + 3;

		var color = r.pick([C_PURPLE, C_BLUE]);

		entity.add(new SpriteAnim(BRAZIER, speed, C_GRAY, color, OBJECTS));
		entity.add(new Moniker('Brazier'));
		entity.add(new Collider());
		entity.add(new LightSource(1.6, color, 4));
		entity.add(new FuelConsumer([FUEL_WOOD], 5000, 5000, 1, true, true));
		entity.add(new Destructable());

		return entity;
	}
}
