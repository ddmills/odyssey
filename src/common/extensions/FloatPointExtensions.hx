package common.extensions;

import common.struct.Coordinate;
import common.struct.FloatPoint;
import common.struct.IntPoint;

class FloatPointExtensions
{
	static public inline function lerp(a:FloatPoint, b:FloatPoint, t:Float):FloatPoint
	{
		return {
			x: a.x.lerp(b.x, t),
			y: a.y.lerp(b.y, t),
		};
	}

	static public inline function multiply(p:FloatPoint, v:Float):FloatPoint
	{
		return {
			x: p.x * v,
			y: p.y * v,
		};
	}

	static public inline function ciel(p:FloatPoint):IntPoint
	{
		return {
			x: p.x.ciel(),
			y: p.y.ciel(),
		};
	}

	static public inline function floor(p:FloatPoint):IntPoint
	{
		return {
			x: p.x.floor(),
			y: p.y.floor(),
		};
	}

	static public inline function round(p:FloatPoint):IntPoint
	{
		return {
			x: p.x.round(),
			y: p.y.round(),
		};
	}

	static public inline function asWorld(p:FloatPoint)
	{
		return new Coordinate(p.x, p.y, WORLD);
	}
}
