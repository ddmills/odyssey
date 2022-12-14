package common.struct;

import common.util.Projection;

class Coordinate
{
	public final x:Float;
	public final y:Float;
	public final space:Space;

	public inline function new(x:Float, y:Float, space:Space = WORLD)
	{
		this.x = x;
		this.y = y;
		this.space = space;
	}

	public static function FromPoints(points:Array<IntPoint>, space:Space):Array<Coordinate>
	{
		return points.map((p) -> new Coordinate(p.x, p.y, space));
	}

	public inline function toIntPoint()
	{
		return new IntPoint(x.floor(), y.floor());
	}

	public inline function toFloatPoint()
	{
		return new FloatPoint(x, y);
	}
}
