package domain.gen;

import data.TileResources;
import domain.components.Energy;
import domain.components.Glyph;
import domain.prefabs.SnakePrefab;
import ecs.Entity;
import hxd.Rand;

class MapGen
{
	public static function Generate(seed:Int)
	{
		var r = new Rand(seed);
		var grasses = [
			TileResources.GRASS_1,
			TileResources.GRASS_2,
			TileResources.GRASS_3,
			TileResources.GRASS_4,
		];
		var colors = [0x65553b, 0x826b40, 0x757632, 0x8c6d32, 0x718427];

		for (x in 0...64)
		{
			for (y in 0...64)
			{
				var ground = new Entity();
				ground.x = x;
				ground.y = y;

				ground.add(new Glyph(r.pick(grasses), r.pick(colors), r.pick(colors), BACKGROUND));

				if (r.bool(.005))
				{
					var snake = SnakePrefab.Create();
					snake.x = x;
					snake.y = y;
					snake.get(Energy).consumeEnergy(r.integer(0, 50));
				}
			}
		}
	}
}
