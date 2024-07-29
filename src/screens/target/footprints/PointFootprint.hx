package screens.target.footprints;

import common.struct.Coordinate;
import common.struct.IntPoint;

class PointFootprint implements Footprint
{
	public function new() {}

	public function getFootprint(origin:Coordinate, cursor:Coordinate):Array<IntPoint>
	{
		return [cursor.toWorld().toIntPoint()];
	}
}
