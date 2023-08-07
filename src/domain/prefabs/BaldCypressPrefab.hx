package domain.prefabs;

import common.struct.Coordinate;
import core.Game;
import data.AudioKey;
import data.ColorKey;
import data.TileKey;
import domain.components.Collider;
import domain.components.Destructable;
import domain.components.LightBlocker;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class BaldCypressPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);
		var r = Game.instance.world.rand;
		var tileKey:TileKey = r.pick([TREE_BALD_CYPRESS_1, TREE_BALD_CYPRESS_2, TREE_BALD_CYPRESS_3]);
		var destroyAudio = r.pick([WOOD_DESTROY_1, WOOD_DESTROY_2, TREE_FALL_1,]);

		entity.add(new Sprite(tileKey, C_GRAY_2, C_GRAY_2, OBJECTS));
		entity.add(new Moniker('Bald cypress tree'));
		entity.add(new Collider());
		entity.add(new LightBlocker());
		entity.add(new Destructable(TBL_SPWN_TREE_DESTRUCT, destroyAudio));

		return entity;
	}
}
