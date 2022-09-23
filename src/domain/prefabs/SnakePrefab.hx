package domain.prefabs;

import data.ColorKeys;
import domain.components.Energy;
import domain.components.EquipmentSlot;
import domain.components.Health;
import domain.components.Inventory;
import domain.components.IsEnemy;
import domain.components.Level;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stats;
import ecs.Entity;

class SnakePrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var snake = new Entity();

		snake.add(new Sprite(SNAKE, ColorKeys.C_ORANGE_1, ColorKeys.C_BLACK_1, ACTORS));
		snake.add(new Energy());
		snake.add(new Level(1));
		snake.get(Energy).consumeEnergy(10);
		snake.add(new Health());
		snake.add(new Stats(0, 1, 2));
		snake.add(new IsEnemy());
		snake.add(new Moniker('Rattlesnake'));
		snake.add(new Inventory());
		snake.add(new EquipmentSlot('head', 'face', EQ_SLOT_HAND, true));

		snake.get(Health).corpsePrefab = CORPSE_SNAKE;

		snake.get(EquipmentSlot).equip(Spawner.Spawn(STICK));

		return snake;
	}
}
