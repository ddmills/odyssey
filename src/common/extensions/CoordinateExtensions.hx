package common.extensions;

import common.struct.Coordinate;
import common.util.Projection;

class CoordinateExtensions
{
	static public inline function toString(c:Coordinate, precision:Int = null):String
	{
		switch c.space
		{
			case PIXEL:
				return 'P(${c.x},${c.y})';
			case SCREEN:
				return 'S(${c.x},${c.y})';
			case WORLD:
				return 'W(${c.x},${c.y})';
		}
	}

	static public inline function floor(c:Coordinate):Coordinate
	{
		return new Coordinate(c.x.floor(), c.y.floor(), c.space);
	}

	static public inline function round(c:Coordinate):Coordinate
	{
		return new Coordinate(c.x.round(), c.y.round(), c.space);
	}

	static public inline function ciel(c:Coordinate):Coordinate
	{
		return new Coordinate(c.x.ciel(), c.y.ciel(), c.space);
	}

	static public inline function toSpace(c:Coordinate, space:Space):Coordinate
	{
		var px = c.toPx();

		switch space
		{
			case PIXEL:
				return px;
			case SCREEN:
				return Projection.pxToScreen(px.x, px.y);
			case WORLD:
				return Projection.pxToWorld(px.x, px.y);
		}
	}

	static public inline function toWorld(c:Coordinate):Coordinate
	{
		switch c.space
		{
			case PIXEL:
				return Projection.pxToWorld(c.x, c.y);
			case SCREEN:
				return Projection.screenToWorld(c.x, c.y);
			case WORLD:
				return c;
		}
	}

	static public inline function toPx(c:Coordinate):Coordinate
	{
		switch c.space
		{
			case PIXEL:
				return c;
			case SCREEN:
				return Projection.screenToPx(c.x, c.y);
			case WORLD:
				return Projection.worldToPx(c.x, c.y);
		}
	}

	static public inline function toScreen(c:Coordinate):Coordinate
	{
		switch c.space
		{
			case PIXEL:
				return Projection.pxToScreen(c.x, c.y);
			case SCREEN:
				return c;
			case WORLD:
				return Projection.worldToScreen(c.x, c.y);
		}
	}

	static public inline function lerp(a:Coordinate, b:Coordinate, time:Float):Coordinate
	{
		var projected = b.toSpace(a.space);

		return new Coordinate(a.x.lerp(projected.x, time), a.y.lerp(projected.y, time), a.space);
	}

	static public inline function sub(a:Coordinate, b:Coordinate):Coordinate
	{
		var projected = b.toSpace(a.space);

		return new Coordinate(a.x - projected.x, a.y - projected.y, a.space);
	}

	static public inline function add(a:Coordinate, b:Coordinate):Coordinate
	{
		var projected = b.toSpace(a.space);

		return new Coordinate(a.x + projected.x, a.y + projected.y, a.space);
	}

	static public inline function manhattan(a:Coordinate, b:Coordinate):Float
	{
		var projected = b.toSpace(a.space);

		return (a.x - projected.x).abs() + (a.y - projected.y).abs();
	}

	static public inline function distanceSq(a:Coordinate, b:Coordinate, space:Space = WORLD):Float
	{
		var pa = a.toSpace(space);
		var pb = b.toSpace(space);

		var dx = pa.x - pb.x;
		var dy = pa.y - pb.y;

		return dx * dx + dy * dy;
	}

	static public inline function distance(a:Coordinate, b:Coordinate, space:Space = WORLD):Float
	{
		return Math.sqrt(distanceSq(a, b, space));
	}

	static public inline function angle(a:Coordinate):Float
	{
		var atan2 = Math.atan2(a.y, a.x);
		var up = atan2 - 3.92699081698;
		var val = up < 0 ? Math.PI * 2 + up : up;

		return val;
	}

	public static inline function lengthSq(a:Coordinate):Float
	{
		return a.x * a.x + a.y * a.y;
	}

	/**
	 * Returns length (distance to `0,0`) of this Coordinate.
	**/
	public inline function length(a:Coordinate):Float
	{
		return Math.sqrt(lengthSq(a));
	}

	static public inline function normalized(a:Coordinate):{x:Float, y:Float}
	{
		var k = lengthSq(a);
		if (k < hxd.Math.EPSILON)
		{
			k = 0;
		}
		else
		{
			k = hxd.Math.invSqrt(k);
		}

		return {
			x: a.x * k,
			y: a.y * k,
		};
	}

	static public inline function equals(a:Coordinate, b:Coordinate):Bool
	{
		return a.space == b.space && a.x == b.x && a.y == b.y;
	}

	/**
	 * Returns normalized vector from a to b
	**/
	static public inline function direction(a:Coordinate, b:Coordinate):{x:Float, y:Float}
	{
		return b.sub(a).normalized();
	}
}
