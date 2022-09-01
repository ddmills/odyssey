package domain.prefabs;

import core.Game;
import data.TileResources;
import domain.components.Energy;
import domain.components.IsPlayer;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Vision;
import ecs.Entity;

class PlayerPrefab
{
	public static function Create()
	{
		var player = new Entity();

		var sprite = new Sprite(TileResources.HERO, 0xd8cfbd, 0x7e3e32, ACTORS);
		sprite.background = Game.instance.CLEAR_COLOR;

		player.add(sprite);
		player.add(new IsPlayer());
		player.add(new Energy());
		player.add(new Vision(7, 1));
		player.add(new Moniker('You'));
		player.add(new Loot());

		return player;
	}
}
