package domain.prefabs;

import data.LiquidType;
import ecs.Entity;

class VialWhiskeyPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		return Spawner.Spawn(VIAL, null, {
			liquidType: LiquidType.LIQUID_WHISKEY,
			volume: 42,
		});
	}
}
