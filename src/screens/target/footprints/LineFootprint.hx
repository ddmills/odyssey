package screens.target.footprints;

import common.algorithm.Bresenham;
import common.struct.Coordinate;
import common.struct.IntPoint;

class LineFootprint implements Footprint
{
	public function new() {}

	public function getFootprint(origin:Coordinate, cursor:Coordinate):Array<IntPoint>
	{
		return Bresenham.getLine(origin.toIntPoint(), cursor.toIntPoint());
	}
}
