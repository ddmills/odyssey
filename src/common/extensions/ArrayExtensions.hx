package common.extensions;

class ArrayExtensions
{
	@:generic public static function intersection<T>(a:Array<T>, b:Array<T>, fn:(a:T, b:T) -> Bool)
	{
		return Lambda.filter(a, function(itemA)
		{
			return Lambda.find(b, function(itemB)
			{
				return fn(itemA, itemB);
			}) != null;
		});
	}

	@:generic public static function difference<T>(a:Array<T>, b:Array<T>, fn:(a:T, b:T) -> Bool)
	{
		return Lambda.filter(a, function(itemA)
		{
			return Lambda.find(b, function(itemB)
			{
				return fn(itemA, itemB);
			}) == null;
		});
	}

	@:generic public static function findRemove<T>(a:Array<T>, fn:(a:T) -> Bool):Bool
	{
		var idx = a.findIdx(fn);
		if (idx >= 0)
		{
			a.splice(idx, 1);
			return true;
		}
		return false;
	}

	@:generic public static function last<T>(a:Array<T>):Null<T>
	{
		return a.length == 0 ? null : a[a.length - 1];
	}

	// TODO: this is not optimized. Unfortunatly T cannot be used as a Map key.
	// alternate option is to sort the list _before_ counting frequencies
	@:generic public static function mostFrequent<T>(it:Array<T>):Null<T>
	{
		var maxFreq = 0;
		var result = null;

		for (i in 0...it.length)
		{
			var freq = 1;
			for (k in(i + 1)...it.length)
			{
				if (it[i] == it[k])
				{
					freq++;
				}
			}

			if (freq > maxFreq)
			{
				result = it[i];
			}
		}

		return result;
	}
}
