package domain.prefabs;

import core.Game;
import data.TileKey;
import domain.components.Collider;
import domain.components.LightBlocker;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class BaldCypressPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();
		var r = Game.instance.world.rand;
		var tileKey:TileKey = r.pick([TREE_BALD_CYPRESS_1, TREE_BALD_CYPRESS_2, TREE_BALD_CYPRESS_3]);

		entity.add(new Sprite(tileKey, 0x66594f, 0x8c8f7f));
		entity.add(new Moniker('Bald cypress tree'));
		entity.add(new Collider());
		entity.add(new LightBlocker());

		return entity;
	}
}
