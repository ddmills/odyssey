package domain.prefabs;

import common.struct.Coordinate;
import data.LiquidType;
import ecs.Entity;

class BloodSplatterPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		return Spawner.Spawn(PUDDLE, pos, {
			liquidType: LiquidType.LIQUID_BLOOD,
			volume: 2,
		});
	}
}
