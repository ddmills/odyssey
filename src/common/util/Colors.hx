package common.util;

import h3d.Vector;

class Colors
{
	public static function MixPart(p1:Float, p2:Float, t:Float):Float
	{
		var v = (1 - t) * p1.pow(2) + t * p2.pow(2);
		return v.nthRoot(2.2);
	}

	public static function Mix(a:Int, b:Int, t:Float):Int
	{
		var c1 = a.toHxdColor();
		var c2 = b.toHxdColor();

		var r = MixPart(c1.r, c2.r, t);
		var g = MixPart(c1.g, c2.g, t);
		var b = MixPart(c1.b, c2.b, t);

		var v = new Vector(r, g, b);

		return v.toColor();
	}
}
