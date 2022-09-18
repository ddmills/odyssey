package domain.prefabs;

import core.Game;
import data.TileKey;
import domain.components.Collider;
import domain.components.LightBlocker;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class OakTreePrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var entity = new Entity();
		var r = Game.instance.world.rand;
		var tileKey:TileKey = r.pick([TREE_OAK_1, TREE_OAK_2, TREE_OAK_3]);

		entity.add(new Sprite(tileKey, 0x235331, 0x8D450B));
		entity.add(new Moniker('Oak tree'));
		entity.add(new Collider());
		entity.add(new LightBlocker());

		return entity;
	}
}
