package screens.target.footprints;

import common.algorithm.Bresenham;
import common.struct.Coordinate;
import common.struct.IntPoint;

class CircleFootprint implements Footprint
{
	private var radius:Int;

	public function new(radius:Int)
	{
		this.radius = radius;
	}

	public function getFootprint(origin:Coordinate, cursor:Coordinate):Array<IntPoint>
	{
		return Bresenham.getCircle(cursor.toIntPoint(), radius, true);
	}
}
