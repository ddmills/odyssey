package common.extensions;

class FloatExtensions
{
	static public function toString(n:Float):String
	{
		return Std.string(n);
	}

	static public inline function floor(n:Float):Int
	{
		return Math.floor(n);
	}

	static public inline function ciel(n:Float):Int
	{
		return Math.ceil(n);
	}

	static public inline function round(n:Float):Int
	{
		return Math.round(n);
	}

	static public inline function pow(n:Float, exp:Float):Float
	{
		return Math.pow(n, exp);
	}

	static public inline function clamp(n:Float, min:Float, max:Float):Float
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

	static public inline function lerp(from:Float, to:Float, rate:Float):Float
	{
		return from + rate * (to - from);
	}

	static public inline function abs(n:Float):Float
	{
		return Math.abs(n);
	}

	static public inline function toDegrees(n:Float):Float
	{
		return n * (180 / Math.PI);
	}

	static public inline function toRadians(n:Float):Float
	{
		return n / (180 / Math.PI);
	}

	static public inline function nthRoot(n:Float, root:Float):Float
	{
		return Math.pow(n, 1 / root);
	}

	static public inline function format(n:Float, decimals:Int = 2):String
	{
		n = Math.round(n * Math.pow(10, decimals));
		var str = '' + n;
		var len = str.length;
		if (len <= decimals)
		{
			while (len < decimals)
			{
				str = '0' + str;
				len++;
			}
			return '0.' + str;
		}
		else
		{
			return str.substr(0, str.length - decimals) + '.' + str.substr(str.length - decimals);
		}
	}
}
