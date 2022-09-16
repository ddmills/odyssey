package domain.prefabs;

import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class BloodSplatterPrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var blood = new Entity();
		blood.add(new Sprite(BLOOD_SPATTER, 0x701E1E, 0x080604, GROUND));
		blood.add(new Moniker('Blood'));
		return blood;
	}
}
