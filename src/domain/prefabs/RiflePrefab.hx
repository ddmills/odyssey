package domain.prefabs;

import data.SoundResources;
import data.TileResources;
import domain.components.Equipment;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Weapon;
import ecs.Entity;

class RiflePrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var rifle = new Entity();
		rifle.add(new Sprite(TileResources.RIFLE, 0xA5CACA, 0x5F3C1F, OBJECTS));
		rifle.add(new Moniker('Rifle'));
		rifle.add(new Loot());
		rifle.add(new Equipment([EQ_SLOT_HAND], [EQ_SLOT_HAND]));
		rifle.add(new Weapon(WPN_FAMILY_RIFLE));
		rifle.get(Equipment).equipSound = SoundResources.GUN_HANDLE_1;
		rifle.get(Equipment).unequipSound = SoundResources.GUN_HANDLE_4;

		rifle.get(Weapon).accuracy = 3;
		rifle.get(Weapon).baseCost = 110;

		return rifle;
	}
}
