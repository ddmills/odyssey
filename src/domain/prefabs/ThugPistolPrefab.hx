package domain.prefabs;

import common.struct.Coordinate;
import data.TileKey;
import domain.components.Attributes;
import domain.components.Dialog;
import domain.components.Energy;
import domain.components.EquipmentSlot;
import domain.components.FactionMember;
import domain.components.Health;
import domain.components.Inventory;
import domain.components.IsEnemy;
import domain.components.Level;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Vision;
import ecs.Entity;
import hxd.Rand;

class ThugPistolPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate)
	{
		var r = Rand.create();
		var entity = new Entity(pos);

		var tkey:TileKey = r.pick([PERSON_1, PERSON_2, PERSON_3, PERSON_5, PERSON_6, PERSON_7]);

		entity.add(new Sprite(tkey, C_WHITE, C_RED, ACTORS));
		entity.add(new Energy(-10));
		entity.add(new Vision(12));
		entity.add(new FactionMember(FACTION_BANDIT));
		entity.add(new Dialog([DIALOG_VILLAGER]));
		entity.add(new Level(1));
		entity.add(new Health());
		entity.add(new Attributes(0, 0, 3));
		entity.add(new IsEnemy());
		entity.add(new Moniker('Thug'));
		entity.add(new Inventory());

		var rhand = new EquipmentSlot('Right hand', 'handRight', EQ_SLOT_HAND, true);

		entity.add(new EquipmentSlot('Head', 'head', EQ_SLOT_HEAD));
		entity.add(new EquipmentSlot('Face', 'face', EQ_SLOT_FACE));
		entity.add(rhand);
		entity.add(new EquipmentSlot('Left hand', 'handLeft', EQ_SLOT_HAND, true));
		entity.add(new EquipmentSlot('Holster', 'holster', EQ_SLOT_HOLSTER));
		entity.add(new EquipmentSlot('Body', 'body', EQ_SLOT_BODY));
		entity.add(new EquipmentSlot('Legs', 'legs', EQ_SLOT_LEGS));
		entity.add(new EquipmentSlot('Feet', 'feet', EQ_SLOT_FEET));

		entity.get(Health).corpsePrefab = CORPSE_HUMAN;

		rhand.equip(Spawner.Spawn(NAVY_REVOLVER, pos));

		var inv = entity.get(Inventory);
		inv.isOpenable = false;
		inv.addLoot(Spawner.Spawn(PISTOL_AMMO, pos));
		inv.addLoot(Spawner.Spawn(PISTOL_AMMO, pos));

		return entity;
	}
}
