package domain.prefabs;

import core.Game;
import data.TileKey;
import domain.components.Blocker;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class CactusPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var r = Game.instance.world.rand;
		var isFlowering = r.bool(.75);

		var tile:TileKey = isFlowering ? r.pick([CACTUS_1_FLOWER, CACTUS_2_FLOWER]) : r.pick([CACTUS_1, CACTUS_2]);

		var cactus = new Entity();

		var sprite = new Sprite(tile, 0x6C793D, 0xAA0F69, OBJECTS);

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
