package domain.prefabs;

import core.Game;
import data.ColorKeys;
import data.TileKey;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class CactusPrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var r = Game.instance.world.rand;
		var isFlowering = r.bool(.75);

		var tile:TileKey = isFlowering ? r.pick([CACTUS_1_FLOWER, CACTUS_2_FLOWER]) : r.pick([CACTUS_1, CACTUS_2]);

		var cactus = new Entity();

		var sprite = new Sprite(tile, ColorKeys.C_GREEN_3, ColorKeys.C_RED_1, OBJECTS);

		cactus.add(sprite);
		cactus.add(new Collider());

		var name = 'Cactus';

		if (isFlowering)
		{
			name += ' (Flowering)';
		}

		cactus.add(new Moniker(name));

		return cactus;
	}
}
