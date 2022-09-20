package domain.prefabs;

import domain.components.LiquidContainer;
import ecs.Entity;

class VialWhiskeyPrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var entity = Spawner.Spawn(VIAL_EMPTY, options);

		var liquid = entity.get(LiquidContainer);
		liquid.liquidType = LIQUID_WHISKEY;
		liquid.volume = 42;

		return entity;
	}
}
