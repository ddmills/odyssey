package domain.prefabs;

import data.TileResources;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class BloodSplatterPrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var blood = new Entity();
		blood.add(new Sprite(TileResources.BLOOD_SPATTER, 0xAC1111, 0x080604, GROUND));
		blood.add(new Moniker('Blood'));
		return blood;
	}
}
