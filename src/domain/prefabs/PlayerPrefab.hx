package domain.prefabs;

import core.Game;
import data.TileResources;
import domain.components.Energy;
import domain.components.EquipmentSlot;
import domain.components.Health;
import domain.components.Inventory;
import domain.components.IsPlayer;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stats;
import domain.components.Vision;
import ecs.Entity;

class PlayerPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var player = new Entity();

		var sprite = new Sprite(TileResources.HERO, 0xd8cfbd, 0x7e3e32, ACTORS);
		sprite.background = Game.instance.CLEAR_COLOR;

		player.add(sprite);
		player.add(new IsPlayer());
		player.add(new Energy());
		player.add(new Vision(12, 2));
		player.add(new Moniker('Cowboy'));
		player.add(new Inventory());
		player.add(new EquipmentSlot('Head', 'head', EQ_SLOT_HEAD));
		player.add(new EquipmentSlot('Face', 'face', EQ_SLOT_FACE));
		player.add(new EquipmentSlot('Right hand', 'handRight', EQ_SLOT_HAND, true));
		player.add(new EquipmentSlot('Left hand', 'handLeft', EQ_SLOT_HAND, true));
		player.add(new EquipmentSlot('Holster', 'holster', EQ_SLOT_HOLSTER));
		player.add(new EquipmentSlot('Body', 'body', EQ_SLOT_BODY));
		player.add(new EquipmentSlot('Legs', 'legs', EQ_SLOT_LEGS));
		player.add(new EquipmentSlot('Feet', 'feet', EQ_SLOT_FEET));
		player.add(new Health());
		player.add(new Stats(3, 2, 1));

		return player;
	}
}
