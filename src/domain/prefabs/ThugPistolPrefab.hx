package domain.prefabs;

import domain.components.Energy;
import domain.components.EquipmentSlot;
import domain.components.Health;
import domain.components.Inventory;
import domain.components.IsEnemy;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stats;
import ecs.Entity;

class ThugPistolPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var entity = new Entity();

		entity.add(new Sprite(THUG_2, 0xb3ab9b, 0x8A4F1F, ACTORS));
		entity.add(new Energy());
		entity.get(Energy).consumeEnergy(10);
		entity.add(new Health());
		entity.add(new Stats(0, 0, 3));
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

		rhand.equip(Spawner.Spawn(NAVY_REVOLVER));

		return entity;
	}
}