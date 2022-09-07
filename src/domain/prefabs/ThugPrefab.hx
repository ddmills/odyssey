package domain.prefabs;

import data.TileResources;
import domain.components.Energy;
import domain.components.EquipmentSlot;
import domain.components.Health;
import domain.components.Inventory;
import domain.components.IsEnemy;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stats;
import ecs.Entity;

class ThugPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var thug = new Entity();

		thug.add(new Sprite(TileResources.THUG_1, 0xb3ab9b, 0x7e3e32, ACTORS));
		thug.add(new Energy(-10));
		thug.add(new Health());
		thug.add(new Stats(3, 0, 0));
		thug.add(new IsEnemy());
		thug.add(new Moniker('Thug brute'));
		thug.add(new Inventory());

		var rhand = new EquipmentSlot('Right hand', 'handRight', EQ_SLOT_HAND, true);

		thug.add(new EquipmentSlot('Head', 'head', EQ_SLOT_HEAD));
		thug.add(new EquipmentSlot('Face', 'face', EQ_SLOT_FACE));
		thug.add(rhand);
		thug.add(new EquipmentSlot('Left hand', 'handLeft', EQ_SLOT_HAND, true));
		thug.add(new EquipmentSlot('Holster', 'holster', EQ_SLOT_HOLSTER));
		thug.add(new EquipmentSlot('Body', 'body', EQ_SLOT_BODY));
		thug.add(new EquipmentSlot('Legs', 'legs', EQ_SLOT_LEGS));
		thug.add(new EquipmentSlot('Feet', 'feet', EQ_SLOT_FEET));

		thug.get(Health).corpsePrefab = CORPSE_HUMAN;

		rhand.equip(Spawner.Spawn(COACH_GUN));

		return thug;
	}
}
