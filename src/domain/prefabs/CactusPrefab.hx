package domain.prefabs;

import core.Game;
import data.TileResources;
import domain.components.Blocker;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;
import hxd.Rand;

class CactusPrefab
{
	public static function Create(r:Rand)
	{
		var flowerTiles = [TileResources.CACTUS_1_FLOWER, TileResources.CACTUS_2_FLOWER];
		var nonflowerTiles = [TileResources.CACTUS_1, TileResources.CACTUS_2];
		var isFlowering = r.bool(.75);

		var tile = isFlowering ? r.pick(flowerTiles) : r.pick(nonflowerTiles);

		var cactus = new Entity();

		var sprite = new Sprite(tile, 0x6C793D, 0xAA0F69, OBJECTS);
		sprite.background = Game.instance.CLEAR_COLOR;

		cactus.add(sprite);
		cactus.add(new Blocker());

		var name = 'Cactus';

		if (isFlowering)
		{
			name += ' (Flowering)';
		}

		cactus.add(new Moniker(name));

		return cactus;
	}
}
