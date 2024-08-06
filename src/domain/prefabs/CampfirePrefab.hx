package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Combustible;
import domain.components.Destructable;
import domain.components.FuelConsumer;
import domain.components.LightSource;
import domain.components.Moniker;
import domain.components.SpriteAnim;
import ecs.Entity;
import hxd.Rand;

class CampfirePrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);
		var r = Rand.create();

		var speed = (r.rand() * 3) + 3;

		var color = r.pick([C_BLUE, C_RED, C_PURPLE, C_YELLOW]);

		entity.add(new SpriteAnim(CAMPFIRE, speed, C_RED, C_YELLOW, OBJECTS));
		entity.add(new Moniker('Campfire'));
		entity.add(new LightSource(.85, color, 6));
		entity.add(new FuelConsumer([FUEL_WOOD], 5000, 5000, 1, true, true));
		entity.add(new Combustible(ASHES));
		entity.add(new Destructable());

		return entity;
	}
}
