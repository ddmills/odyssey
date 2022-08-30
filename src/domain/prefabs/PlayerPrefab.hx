package domain.prefabs;

import data.TileResources;
import domain.components.Energy;
import domain.components.IsPlayer;
import domain.components.Sprite;
import domain.components.Vision;
import ecs.Entity;

class PlayerPrefab
{
	public static function Create()
	{
		var player = new Entity();

		player.add(new Sprite(TileResources.HERO, 0xd8cfbd, 0x7e3e32, ACTORS));
		player.add(new IsPlayer());
		player.add(new Energy());
		player.add(new Vision(8, 1));

		return player;
	}
}
