package domain.prefabs;

import core.Game;
import data.TileResources;
import domain.components.Equipment;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class StickPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var stick = new Entity();

		var sprite = new Sprite(TileResources.STICK_1, 0x885B07, 0x000000, OBJECTS);
		sprite.background = Game.instance.CLEAR_COLOR;
		stick.add(sprite);
		stick.add(new Moniker('Stick'));
		stick.add(new Loot());
		stick.add(new Equipment([EQ_SLOT_HAND]));

		return stick;
	}
}
