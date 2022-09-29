package common.extensions;

class IntExtensions
{
	static public inline function toString(n:Int):String
	{
		return Std.string(n);
	}

	static public inline function isEven(n:Int):Bool
	{
		return n % 2 == 0;
	}

	static public inline function isOdd(n:Int):Bool
	{
		return n % 2 == 1;
	}

	static public inline function abs(n:Int):Int
	{
		return n <= 0 ? -n : n;
	}

	static public inline function pow(n:Int, exp:Int):Int
	{
		return Math.pow(n, exp).floor();
	}

	static public inline function toHxdColor(n:Int, a:Float = 1):h3d.Vector
	{
		var b = n & 0xff;
		var g = (n >> 8) & 0xff;
		var r = (n >> 16) & 0xff;

		return new h3d.Vector(r / 255, g / 255, b / 255, a);
	}

	static public inline function clampUpper(n:Int, max:Int):Int
	{
		return n > max ? max : n;
	}

	static public inline function clampLower(n:Int, min:Int):Int
	{
		return n < min ? min : n;
	}

	static public inline function clamp(n:Int, min:Int, max:Int):Int
	{
		if (n > max)
		{
			return max;
		}
		if (n < min)
		{
			return min;
		}
		return n;
	}
}
