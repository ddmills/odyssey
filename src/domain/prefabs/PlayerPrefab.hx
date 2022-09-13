package domain.prefabs;

import core.Game;
import data.SpawnableType;
import domain.components.Energy;
import domain.components.EquipmentSlot;
import domain.components.Health;
import domain.components.Inventory;
import domain.components.IsPlayer;
import domain.components.Level;
import domain.components.Moniker;
import domain.components.Moved;
import domain.components.Sprite;
import domain.components.Stats;
import domain.components.Vision;
import domain.events.SpawnedEvent;
import ecs.Entity;
import hxd.Rand;

class PlayerPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var entity = new Entity();

		var sprite = new Sprite(HERO, 0xd8cfbd, 0x7e3e32, ACTORS);
		// sprite.background = Game.instance.CLEAR_COLOR;

		entity.add(sprite);
		entity.add(new IsPlayer());
		entity.add(new Energy());
		entity.add(new Level(20));
		entity.add(new Vision(12, 2));
		entity.add(new Moniker('Cowboy'));
		entity.add(new Inventory());
		entity.add(new EquipmentSlot('Head', 'head', EQ_SLOT_HEAD));
		entity.add(new EquipmentSlot('Face', 'face', EQ_SLOT_FACE));
		var rhand = new EquipmentSlot('Right hand', 'handRight', EQ_SLOT_HAND, true);

		entity.add(rhand);
		entity.add(new EquipmentSlot('Left hand', 'handLeft', EQ_SLOT_HAND, true));
		entity.add(new EquipmentSlot('Holster', 'holster', EQ_SLOT_HOLSTER));

		var body = new EquipmentSlot('Body', 'body', EQ_SLOT_BODY);
		entity.add(body);
		entity.add(new EquipmentSlot('Legs', 'legs', EQ_SLOT_LEGS));
		entity.add(new EquipmentSlot('Feet', 'feet', EQ_SLOT_FEET));
		entity.add(new Health());
		entity.add(new Stats(3, 2, 1));

		var wpns:Array<SpawnableType> = [NAVY_REVOLVER, COACH_GUN, RIFLE];
		rhand.equip(Spawner.Spawn(Rand.create().pick(wpns)));
		body.equip(Spawner.Spawn(LONG_JOHNS));

		entity.get(Inventory).addLoot(Spawner.Spawn(STICK));
		entity.get(Inventory).addLoot(Spawner.Spawn(STICK));
		entity.get(Inventory).addLoot(Spawner.Spawn(STICK));
		entity.get(Inventory).addLoot(Spawner.Spawn(STICK));
		entity.get(Inventory).addLoot(Spawner.Spawn(STICK));

		return entity;
	}
}
