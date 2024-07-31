package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class SignpostPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);
		var text = options.text ?? 'scribbles';

		entity.add(new Sprite(SIGNPOST, C_RED_3, C_YELLOW_1, OBJECTS));
		entity.add(new Moniker('Signpost ($text)'));
		entity.add(new Collider());

		return entity;
	}
}
