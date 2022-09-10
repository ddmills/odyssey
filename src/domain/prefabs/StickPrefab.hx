package domain.prefabs;

import core.Game;
import data.TileResources;
import domain.components.Equipment;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Weapon;
import ecs.Entity;

class StickPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var entity = new Entity();

		var sprite = new Sprite(TileResources.STICK_1, 0x885B07, 0x000000, OBJECTS);
		sprite.background = Game.instance.CLEAR_COLOR;
		entity.add(sprite);
		entity.add(new Moniker('Stick'));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_HAND]));
		entity.add(new Weapon(WPN_FAMILY_CUDGEL));

		return entity;
	}
}
