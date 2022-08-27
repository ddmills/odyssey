package domain.gen;

import data.TileResources;
import domain.components.Glyph;
import ecs.Entity;
import hxd.Rand;

class MapGen
{
	public static function Generate(seed:Int)
	{
		var r = new Rand(seed);
		var grasses = [
			TileResources.GRASS1,
			TileResources.GRASS2,
			TileResources.GRASS3,
			TileResources.GRASS4
		];
		var colors = [0x65553b, 0x826b40, 0x757632, 0x8c6d32, 0x718427];

		for (x in 0...64)
		{
			for (y in 0...64)
			{
				var ground = new Entity();
				ground.x = x;
				ground.y = y;

				ground.add(new Glyph(r.pick(grasses), r.pick(colors)));
			}
		}
	}
}
