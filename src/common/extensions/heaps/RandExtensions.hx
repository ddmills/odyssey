package common.extensions.heaps;

class RandExtensions
{
	public static function integer<T>(r:hxd.Rand, min:Int, max:Int):Int
	{
		return min + (r.rand() * (max - min)).floor();
	}

	public static function bool<T>(r:hxd.Rand, chance = .5):Bool
	{
		return r.rand() < chance;
	}

	public static function pick<T>(r:hxd.Rand, array:Array<T>):T
	{
		return array[r.random(array.length)];
	}

	public static function pickIdx<T>(r:hxd.Rand, array:Array<T>):Int
	{
		return Math.floor(r.rand() * array.length);
	}

	public static function roll(r:hxd.Rand, faces:Int, mod:Int = 0):Int
	{
		return r.integer(1, faces + 1) + mod;
	}
}
