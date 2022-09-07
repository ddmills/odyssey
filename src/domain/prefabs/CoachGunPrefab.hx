package domain.prefabs;

import data.SoundResources;
import data.TileResources;
import domain.components.Equipment;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Weapon;
import ecs.Entity;

class CoachGunPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var rifle = new Entity();
		rifle.add(new Sprite(TileResources.COACH_GUN, 0xA5CACA, 0x5F3C1F, OBJECTS));
		rifle.add(new Moniker('Coach gun'));
		rifle.add(new Loot());
		rifle.add(new Equipment([EQ_SLOT_HAND], [EQ_SLOT_HAND]));
		rifle.add(new Weapon(WPN_FAMILY_SHOTGUN));
		rifle.get(Equipment).equipSound = SoundResources.GUN_HANDLE_1;
		rifle.get(Equipment).unequipSound = SoundResources.GUN_HANDLE_4;

		rifle.get(Weapon).accuracy = -2;
		rifle.get(Weapon).modifier = 5;
		rifle.get(Weapon).baseCost = 80;

		return rifle;
	}
}
