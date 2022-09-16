package domain.prefabs;

import data.SpawnableType;
import data.TileKey;
import domain.components.Energy;
import domain.components.EquipmentSlot;
import domain.components.Health;
import domain.components.Inventory;
import domain.components.IsPlayer;
import domain.components.Level;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stats;
import domain.components.Vision;
import ecs.Entity;
import hxd.Rand;

class PlayerPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var r = Rand.create();
		var entity = new Entity();

		var tkey:TileKey = r.pick([PERSON_1, PERSON_2, PERSON_3, PERSON_4, PERSON_5, PERSON_6, PERSON_7]);

		entity.add(new Sprite(tkey, 0x968a8a, 0x1A6C85, ACTORS));
		entity.add(new IsPlayer());
		entity.add(new Energy());
		entity.add(new Level(120));
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
		rhand.equip(Spawner.Spawn(r.pick(wpns)));
		body.equip(Spawner.Spawn(LONG_JOHNS));

		entity.get(Inventory).addLoot(Spawner.Spawn(PISTOL_AMMO));
		entity.get(Inventory).addLoot(Spawner.Spawn(RIFLE_AMMO));
		entity.get(Inventory).addLoot(Spawner.Spawn(SHOTGUN_AMMO));
		entity.get(Inventory).addLoot(Spawner.Spawn(SNUB_NOSE_REVOLVER));
		entity.get(Inventory).addLoot(Spawner.Spawn(REVOLVER));
		entity.get(Inventory).addLoot(Spawner.Spawn(NAVY_REVOLVER));

		return entity;
	}
}
