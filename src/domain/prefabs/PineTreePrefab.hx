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
		var tileKey:TileKey = r.pick([PINE_TREE_1, PINE_TREE_2, PINE_TREE_3, PINE_TREE_4,]);

		entity.add(new Sprite(tileKey, 0x235331, 0x8D450B));
		entity.add(new Moniker('Pine tree'));
		entity.add(new Blocker());

		return entity;
	}
}
