package screens.target.footprints;

import common.struct.Coordinate;
import common.struct.IntPoint;

interface Footprint
{
	public function getFootprint(origin:Coordinate, cursor:Coordinate):Array<IntPoint>;
}
