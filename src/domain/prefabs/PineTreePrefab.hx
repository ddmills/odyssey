package domain.prefabs;

import core.Game;
import data.TileKey;
import domain.components.Blocker;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class PineTreePrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var entity = new Entity();
		var r = Game.instance.world.rand;
		var tileKey:TileKey = r.pick([TREE_PINE_1, TREE_PINE_2, TREE_PINE_3, TREE_PINE_4,]);

		entity.add(new Sprite(tileKey, 0x235331, 0x8D450B));
		entity.add(new Moniker('Pine tree'));
		entity.add(new Blocker());

		return entity;
	}
}
