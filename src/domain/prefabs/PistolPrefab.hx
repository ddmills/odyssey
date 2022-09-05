package domain.prefabs;

import data.SoundResources;
import data.TileResources;
import domain.components.Equipment;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class PistolPrefab extends Prefab
{
	public function Create(?options:Dynamic)
	{
		var pistol = new Entity();
		pistol.add(new Sprite(TileResources.PISTOL, 0xA5CACA, 0x5F3C1F, OBJECTS));
		pistol.add(new Moniker('Pistol'));
		pistol.add(new Loot());
		pistol.add(new Equipment([EQ_SLOT_HAND]));

		pistol.get(Equipment).equipSound = SoundResources.GUN_HANDLE_1;
		pistol.get(Equipment).unequipSound = SoundResources.GUN_HANDLE_4;

		return pistol;
	}
}
