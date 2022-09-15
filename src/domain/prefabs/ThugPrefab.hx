package domain.prefabs;

import domain.components.Energy;
import domain.components.EquipmentSlot;
import domain.components.Health;
import domain.components.Inventory;
import domain.components.IsEnemy;
import domain.components.Level;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stats;
import ecs.Entity;

class ThugPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var entity = new Entity();

		entity.add(new Sprite(THUG_1, 0xb3ab9b, 0x8A4F1F, ACTORS));
		entity.add(new Energy());
		entity.get(Energy).consumeEnergy(10);
		entity.add(new Level(2));
		entity.add(new Health());
		entity.add(new Stats(3, 0, 0));
		entity.add(new IsEnemy());
		entity.add(new Moniker('Thug brute'));
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

		rhand.equip(Spawner.Spawn(COACH_GUN));

		var inv = entity.get(Inventory);
		inv.addLoot(Spawner.Spawn(SHOTGUN_AMMO));
		inv.addLoot(Spawner.Spawn(SHOTGUN_AMMO));

		return entity;
	}
}
