package domain.prefabs;

import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class BloodSplatterPrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var blood = new Entity();
		blood.add(new Sprite(PUDDLE_1, 0x701E1E, 0x2C0808, GROUND));
		blood.add(new Moniker('Blood'));
		return blood;
	}
}
