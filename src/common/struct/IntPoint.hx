package common.struct;

import data.Cardinal;

@:structInit class IntPoint
{
	public final x:Int;
	public final y:Int;

	public inline function new(x:Int, y:Int)
	{
		this.x = x;
		this.y = y;
	}

	public function equals(other:IntPoint)
	{
		return Equals(this, other);
	}

	public static function Equals(point:IntPoint, other:IntPoint)
	{
		return other.x == point.x && other.y == point.y;
	}

	public function asWorld()
	{
		return new Coordinate(x, y, WORLD);
	}

	public function asZone()
	{
		return new Coordinate(x, y, ZONE);
	}

	public function toString()
	{
		return '(${x},${y})';
	}

	public overload extern inline function sub(other:IntPoint):IntPoint
	{
		return new IntPoint(x - other.x, y - other.y);
	}

	public overload extern inline function sub(x:Int, y:Int):IntPoint
	{
		return new IntPoint(this.x - x, this.y - y);
	}

	public overload extern inline function add(other:IntPoint):IntPoint
	{
		return new IntPoint(x + other.x, y + other.y);
	}

	public overload extern inline function add(x:Int, y:Int):IntPoint
	{
		return new IntPoint(this.x + x, this.y + y);
	}

	public overload extern inline function multiply(v:Int):IntPoint
	{
		return new IntPoint(x * v, y * v);
	}

	public overload extern inline function divide(v:Float):FloatPoint
	{
		return new FloatPoint(x / v, y / v);
	}

	public inline function dot(other:IntPoint):Int
	{
		return (x + other.x) * (y + other.y);
	}

	public inline function radians():Float
	{
		var rad = Math.atan2(y, x);
		return rad < 0 ? Math.PI * 2 + rad : rad;
	}

	public inline function degrees():Float
	{
		return radians().toDegrees();
	}

	public inline function cardinal():Cardinal
	{
		return Cardinal.fromRadians(radians());
	}
}
