package domain;

import domain.terrain.TerrainType;

class MapData
{
	public function new() {}

	public function initialize() {}

	public function getTerrain(wx:Float, wy:Float):TerrainType
	{
		return GRASS;
	}
}
