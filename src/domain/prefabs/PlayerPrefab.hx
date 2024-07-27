package domain.prefabs;

import common.struct.Coordinate;
import data.ColorKey;
import data.SpawnableType;
import data.TileKey;
import domain.components.Attributes;
import domain.components.Energy;
import domain.components.EquipmentSlot;
import domain.components.FactionMember;
import domain.components.Health;
import domain.components.Inventory;
import domain.components.IsPlayer;
import domain.components.Level;
import domain.components.Moniker;
import domain.components.Sleeper;
import domain.components.Sprite;
import domain.components.Vision;
import ecs.Entity;
import hxd.Rand;

class PlayerPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var r = Rand.create();
		var entity = new Entity(pos);

		var tkey:TileKey = r.pick([
			PERSON_1, PERSON_2, PERSON_3, PERSON_4, PERSON_5, PERSON_6, PERSON_7, PERSON_8, PERSON_9, PERSON_10,
		]);

		entity.add(new Sprite(tkey, C_YELLOW_0, C_BLUE_4, ACTORS));
		entity.add(new IsPlayer());
		entity.add(new FactionMember(FACTION_PLAYER));
		entity.add(new Energy(10));
		entity.add(new Level(2));
		entity.add(new Vision(20));
		entity.add(new Sleeper());
		entity.add(new Moniker('Cowboy'));
		entity.add(new Inventory());
		entity.add(new EquipmentSlot('Head', 'head', EQ_SLOT_HEAD));
		entity.add(new EquipmentSlot('Face', 'face', EQ_SLOT_FACE));

		var rhand = new EquipmentSlot('Right hand', 'handRight', EQ_SLOT_HAND, true);

		entity.add(rhand);
		entity.add(new EquipmentSlot('Left hand', 'handLeft', EQ_SLOT_HAND, true));
		entity.add(new EquipmentSlot('Holster', 'holster', EQ_SLOT_HOLSTER));
		entity.add(new EquipmentSlot('Belt', 'belt', EQ_SLOT_BELT));

		var body = new EquipmentSlot('Body', 'body', EQ_SLOT_BODY);
		entity.add(body);
		entity.add(new EquipmentSlot('Legs', 'legs', EQ_SLOT_LEGS));
		entity.add(new EquipmentSlot('Feet', 'feet', EQ_SLOT_FEET));
		entity.add(new Health());

		var attributes = new Attributes(2, 2, 2);
		attributes.unlockSkill(SKILL_PISTOLS, true);
		attributes.unlockSkill(SKILL_BARRAGE, true);
		entity.add(attributes);

		rhand.equip(Spawner.Spawn(NAVY_REVOLVER, pos));
		body.equip(Spawner.Spawn(LONG_JOHNS, pos));

		var inv = entity.get(Inventory);

		inv.addLoot(Spawner.Spawn(LANTERN, pos));
		inv.addLoot(Spawner.Spawn(BEDROLL, pos));
		inv.addLoot(Spawner.Spawn(PISTOL_AMMO, pos));
		inv.addLoot(Spawner.Spawn(RIFLE_AMMO, pos));
		inv.addLoot(Spawner.Spawn(SHOTGUN_AMMO, pos));
		inv.addLoot(Spawner.Spawn(REVOLVER, pos));
		inv.addLoot(Spawner.Spawn(RIFLE, pos));
		inv.addLoot(Spawner.Spawn(VIAL_WHISKEY, pos));
		inv.addLoot(Spawner.Spawn(VIAL_WHISKEY, pos));
		inv.addLoot(Spawner.Spawn(DYNAMITE, pos));
		inv.addLoot(Spawner.Spawn(DYNAMITE, pos));
		inv.addLoot(Spawner.Spawn(DYNAMITE, pos));
		inv.addLoot(Spawner.Spawn(DYNAMITE, pos));
		inv.addLoot(Spawner.Spawn(DYNAMITE, pos));
		inv.addLoot(Spawner.Spawn(DYNAMITE, pos));
		inv.addLoot(Spawner.Spawn(DYNAMITE, pos));

		return entity;
	}
}
