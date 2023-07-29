package screens.target.footprints;

import common.algorithm.Bresenham;
import common.struct.ComplexSet;
import common.struct.Coordinate;
import common.struct.FloatPoint;
import common.struct.IntPoint;
import common.struct.Set;

class ConeFootprint implements Footprint
{
	private var radius:Int;
	private var angle:Float;

	public function new(radius:Int, angle:Int)
	{
		this.radius = radius;
		this.angle = angle.toRadians();
	}

	public function getFootprint(origin:Coordinate, cursor:Coordinate):Array<IntPoint>
	{
		var dir = origin.direction(cursor);

		var s = Math.sin(-(angle / 2));
		var c = Math.cos(-(angle / 2));
		var tip = dir.multiply(radius + .25);
		var left = new FloatPoint((tip.x * c - tip.y * s), (tip.x * s + tip.y * c));

		var s2 = Math.sin((angle / 2));
		var c2 = Math.cos((angle / 2));
		var right = new FloatPoint((tip.x * c2 - tip.y * s2), (tip.x * s2 + tip.y * c2));

		var polygon = new Array<IntPoint>();
		polygon.push(origin.add(dir.round().asWorld()).toIntPoint());
		polygon.push(origin.add(left.round().asWorld()).toIntPoint());
		polygon.push(origin.add(tip.asWorld()).toIntPoint());
		polygon.push(origin.add(right.round().asWorld()).toIntPoint());
		var points = new ComplexSet<IntPoint>(IntPoint.Equals);

		Bresenham.fillPolygon(polygon, (p) -> points.add(p));
		Bresenham.strokePolygon(polygon, (p) -> points.add(p)); // TODO: fix polygon fill!!

		return points.asArray();
	}
}
