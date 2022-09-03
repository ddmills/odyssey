package domain.prefabs;

import data.TileResources;
import domain.components.Equipment;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class PistolPrefab
{
	public static function Create()
	{
		var pistol = new Entity();
		pistol.add(new Sprite(TileResources.PISTOL, 0xA5CACA, 0x5F3C1F, ACTORS));
		pistol.add(new Moniker('Pistol'));
		pistol.add(new Loot());
		pistol.add(new Equipment([EQ_SLOT_HAND]));
		return pistol;
	}
}
