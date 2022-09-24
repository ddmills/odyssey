package domain.prefabs;

import data.ColorKeys;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class AshPilePrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(PILE_ASH, ColorKeys.C_GRAY_1, ColorKeys.C_GRAY_2, OBJECTS));
		entity.add(new Moniker('Pile of ashes'));
		entity.add(new Loot());

		return entity;
	}
}