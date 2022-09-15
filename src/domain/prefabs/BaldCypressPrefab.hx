package domain.prefabs;

import core.Game;
import data.TileKey;
import domain.components.Blocker;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class BaldCypressPrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var entity = new Entity();
		var r = Game.instance.world.rand;
		var tileKey:TileKey = r.pick([
			BALD_CYPRESS_V1_1,
			BALD_CYPRESS_V1_2,
			BALD_CYPRESS_V1_3,
			// BALD_CYPRESS_V2_1,
			// BALD_CYPRESS_V2_2,
			// BALD_CYPRESS_V2_3,
		]);

		entity.add(new Sprite(tileKey, 0x66594f, 0x8c8f7f));
		entity.add(new Moniker('Bald cypress tree'));
		entity.add(new Blocker());

		return entity;
	}
}
