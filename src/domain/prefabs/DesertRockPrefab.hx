package domain.prefabs;

import core.Game;
import data.ColorKey;
import data.TileKey;
import domain.components.Collider;
import domain.components.LightBlocker;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class DesertRockPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();
		var r = Game.instance.world.rand;
		var tileKey = r.pick([ROCK_ROUND_1, ROCK_ROUND_2, ROCK_ROUND_3, ROCK_ROUND_4]);

		entity.add(new Sprite(tileKey, C_RED_2, C_RED_1, OBJECTS));
		entity.add(new Moniker('Rock'));
		entity.add(new Collider());
		entity.add(new LightBlocker());

		return entity;
	}
}
