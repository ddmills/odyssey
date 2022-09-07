package domain.prefabs;

import data.SoundResources;
import data.TileResources;
import domain.components.Equipment;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Weapon;
import ecs.Entity;

class NavyRevoloverPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var pistol = new Entity();
		pistol.add(new Sprite(TileResources.NAVY_REVOLVER, 0xA5CACA, 0x5F3C1F, OBJECTS));
		pistol.add(new Moniker('Navy revolover'));
		pistol.add(new Loot());
		pistol.add(new Equipment([EQ_SLOT_HAND, EQ_SLOT_HOLSTER]));
		pistol.add(new Weapon(WPN_FAMILY_PISTOL));
		pistol.get(Equipment).equipSound = SoundResources.GUN_HANDLE_1;
		pistol.get(Equipment).unequipSound = SoundResources.GUN_HANDLE_4;

		pistol.get(Weapon).baseCost = 60;

		return pistol;
	}
}
