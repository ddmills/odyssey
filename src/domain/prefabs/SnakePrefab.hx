package domain.prefabs;

import data.TileResources;
import domain.components.Energy;
import domain.components.Glyph;
import ecs.Entity;

class SnakePrefab
{
	public static function Create()
	{
		var snake = new Entity();

		snake.add(new Glyph(TileResources.SNAKE_1, 0xDF9100, 0x000000, ACTORS));
		snake.add(new Energy(-10));

		return snake;
	}
}
