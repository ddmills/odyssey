package domain.gen;

import data.TileResources;
import domain.components.Glyph;
import ecs.Entity;

class MapGen
{
	public static function Generate(seed:Int)
	{
		for (x in 0...8)
		{
			for (y in 0...8)
			{
				var ground = new Entity();
				ground.x = x;
				ground.y = y;

				ground.add(new Glyph(TileResources.GRASS, ','));
			}
		}
	}
}
