package domain.prefabs;

import data.TileResources;
import domain.components.Energy;
import domain.components.EquipmentSlot;
import domain.components.Health;
import domain.components.IsEnemy;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stats;
import ecs.Entity;

class SnakePrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var snake = new Entity();

		snake.add(new Sprite(TileResources.SNAKE_1, 0xDF9100, 0x000000, ACTORS));
		snake.add(new Energy(-10));
		snake.add(new Health());
		snake.add(new Stats(0, 1, 2));
		snake.add(new IsEnemy());
		snake.add(new Moniker('Rattlesnake'));
		snake.add(new EquipmentSlot('head', 'face', EQ_SLOT_FACE, true));

		snake.get(Health).corpsePrefab = SNAKE_CORPSE;

		return snake;
	}
}
