package domain.prefabs;

import data.LiquidType;
import ecs.Entity;

class BloodSplatterPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		return Spawner.Spawn(PUDDLE, null, {
			liquidType: LiquidType.LIQUID_BLOOD,
			volume: 2,
		});
	}
}
