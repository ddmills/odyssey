package common.struct;

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
		return other.x == x && other.y == y;
	}

	public function asWorld()
	{
		return new Coordinate(x, y, WORLD);
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

	public inline function dot(other:IntPoint):Int
	{
		return (x + other.x) * (y + other.y);
	}

	public inline function angle():Float
	{
		var atan2 = Math.atan2(y, x);
		var up = atan2 - 3.92699081698;
		var val = up < 0 ? Math.PI * 2 + up : up;

		return val;
	}
}
