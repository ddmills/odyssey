package domain.prefabs;

import common.struct.Coordinate;
import core.Game;
import data.ColorKey;
import data.TileKey;
import domain.components.Collider;
import domain.components.Destructable;
import domain.components.Forageable;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class CactusPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var r = Game.instance.world.rand;
		var isFlowering = r.bool(.75);

		var tile:TileKey = isFlowering ? r.pick([CACTUS_1_FLOWER, CACTUS_2_FLOWER]) : r.pick([CACTUS_1, CACTUS_2]);

		var entity = new Entity(pos);
		var sprite = new Sprite(tile, C_GREEN_2, C_RED_1, OBJECTS);

		entity.add(sprite);
		entity.add(new Collider());

		var name = 'Cactus';

		if (isFlowering)
		{
			name += ' (Flowering)';
			entity.add(new Forageable(CACTUS_FRUIT, RUSTLING_1, false, C_GREEN_3, C_GREEN_4, CACTUS_1));
		}

		entity.add(new Moniker(name));
		entity.add(new Destructable());

		return entity;
	}
}
