package domain.prefabs;

import common.struct.Coordinate;
import data.LiquidType;
import ecs.Entity;

class VialWaterPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		return Spawner.Spawn(VIAL, pos, {
			liquidType: LiquidType.LIQUID_WATER,
			volume: 42,
		});
	}
}
