package domain.gen;

import data.TileResources;
import domain.components.Energy;
import domain.components.Sprite;
import domain.prefabs.SnakePrefab;
import domain.prefabs.StickPrefab;
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
		var colors = [0x47423a, 0x5f523a, 0x4F502F, 0x57482e, 0x495228];

		for (x in 0...64)
		{
			for (y in 0...64)
			{
				var ground = new Entity();
				ground.x = x;
				ground.y = y;

				ground.add(new Sprite(r.pick(grasses), r.pick(colors), r.pick(colors), BACKGROUND));

				if (r.bool(.005))
				{
					var snake = SnakePrefab.Create();
					snake.x = x;
					snake.y = y;
					snake.get(Energy).consumeEnergy(r.integer(0, 50));
				}

				if (r.bool(.005))
				{
					var stick = StickPrefab.Create();
					stick.x = x;
					stick.y = y;
				}
			}
		}
	}
}
