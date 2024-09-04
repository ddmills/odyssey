package common.util;

typedef RGB =
{
	r:Int,
	g:Int,
	b:Int,
}

class Colors
{
	public static inline function Components(c:Int):RGB
	{
		return {
			r: (c & 0xff0000) >> 16,
			g: (c & 0x00ff00) >> 8,
			b: (c & 0x0000ff)
		};
	}

	public static inline function ToHex(r:Int, g:Int, b:Int):Int
	{
		return (r << 16) + (g << 8) + (b);
	}

	public static function MixPart(p1:Float, p2:Float, t:Float):Float
	{
		var v = (1 - t) * p1.pow(2) + t * p2.pow(2);
		return v.nthRoot(2);
	}

	public static function Mix(a:Int, b:Int, t:Float = .5):Int
	{
		var c1 = Components(a);
		var c2 = Components(b);

		var r = MixPart(c1.r, c2.r, t).clamp(0, 255).round();
		var g = MixPart(c1.g, c2.g, t).clamp(0, 255).round();
		var b = MixPart(c1.b, c2.b, t).clamp(0, 255).round();

		return ToHex(r, g, b);
	}
}
