package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import domain.components.Collider;
import domain.components.Destructable;
import domain.components.LightSource;
import domain.components.Lightable;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class StreetlampPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var isLit = options.isLit == null ? true : options.isLit;
		var entity = new Entity(pos);

		entity.add(new Sprite(STREETLAMP, C_BLUE, C_CLEAR, OBJECTS));
		entity.add(new Moniker('Streetlamp'));
		entity.add(new Lightable(true, C_YELLOW));
		entity.add(new LightSource(1.4, C_FIRE_LIGHT, 2, isLit));
		entity.add(new Destructable());
		entity.add(new Collider());

		return entity;
	}
}
