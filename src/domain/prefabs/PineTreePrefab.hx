package domain.prefabs;

import core.Game;
import data.ColorKeys;
import data.TileKey;
import domain.components.Collider;
import domain.components.LightBlocker;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class PineTreePrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();
		var r = Game.instance.world.rand;
		var tileKey:TileKey = r.pick([TREE_PINE_1, TREE_PINE_2, TREE_PINE_3, TREE_PINE_4,]);

		entity.add(new Sprite(tileKey, ColorKeys.C_GREEN_3, ColorKeys.C_ORANGE_2));
		entity.add(new Moniker('Pine tree'));
		entity.add(new Collider());
		entity.add(new LightBlocker());

		return entity;
	}
}
