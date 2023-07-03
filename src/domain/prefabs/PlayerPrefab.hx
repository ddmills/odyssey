package domain.prefabs;

import data.ColorKey;
import data.LiquidType;
import data.SpawnableType;
import data.TileKey;
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
import domain.components.Stats;
import domain.components.Vision;
import ecs.Entity;
import hxd.Rand;

class PlayerPrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var r = Rand.create();
		var entity = new Entity();

		var tkey:TileKey = r.pick([
			PERSON_1, PERSON_2, PERSON_3, PERSON_4, PERSON_5, PERSON_6, PERSON_7, PERSON_8, PERSON_9, PERSON_10,
		]);

		entity.add(new Sprite(tkey, C_WHITE_1, C_BLUE_2, ACTORS));
		entity.add(new IsPlayer());
		entity.add(new FactionMember(FACTION_PLAYER));
		entity.add(new Energy(10));
		entity.add(new Level(120));
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
		entity.add(new Stats(3, 2, 1));

		var wpns:Array<SpawnableType> = [NAVY_REVOLVER, COACH_GUN, RIFLE];
		rhand.equip(Spawner.Spawn(r.pick(wpns)));
		body.equip(Spawner.Spawn(LONG_JOHNS));

		var inv = entity.get(Inventory);

		inv.addLoot(Spawner.Spawn(LANTERN));
		inv.addLoot(Spawner.Spawn(BEDROLL));
		inv.addLoot(Spawner.Spawn(PISTOL_AMMO));
		inv.addLoot(Spawner.Spawn(RIFLE_AMMO));
		inv.addLoot(Spawner.Spawn(SHOTGUN_AMMO));
		inv.addLoot(Spawner.Spawn(REVOLVER));
		inv.addLoot(Spawner.Spawn(VIAL_WHISKEY));
		inv.addLoot(Spawner.Spawn(VIAL_WHISKEY));
		inv.addLoot(Spawner.Spawn(VIAL));
		inv.addLoot(Spawner.Spawn(JAR));
		inv.addLoot(Spawner.Spawn(STICK));
		inv.addLoot(Spawner.Spawn(STICK));
		inv.addLoot(Spawner.Spawn(STICK));
		inv.addLoot(Spawner.Spawn(STICK));
		inv.addLoot(Spawner.Spawn(STICK));
		inv.addLoot(Spawner.Spawn(STICK));

		inv.addLoot(Spawner.Spawn(VIAL, null, {
			liquidType: LiquidType.LIQUID_WATER,
			volume: 42,
		}));

		inv.addLoot(Spawner.Spawn(VIAL, null, {
			liquidType: LiquidType.LIQUID_BLOOD,
			volume: 42,
		}));

		inv.addLoot(Spawner.Spawn(VIAL, null, {
			liquidType: LiquidType.LIQUID_HONEY,
			volume: 42,
		}));

		inv.addLoot(Spawner.Spawn(VIAL, null, {
			liquidType: LiquidType.LIQUID_WHALE_OIL,
			volume: 42,
		}));

		return entity;
	}
}
