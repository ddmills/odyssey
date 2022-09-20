package domain.prefabs;

import common.struct.Coordinate;
import domain.data.liquids.Liquids;
import ecs.Entity;

class BloodSplatterPrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var entity = Liquids.get(LIQUID_BLOOD).createPuddle(new Coordinate(0, 0, WORLD), 5);

		return entity;
	}
}
