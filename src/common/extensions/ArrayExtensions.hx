package common.extensions;

class ArrayExtensions
{
	public static function intersection<T>(a:Array<T>, b:Array<T>, fn:(a:T, b:T) -> Bool)
	{
		return Lambda.filter(a, function(itemA)
		{
			return Lambda.find(b, function(itemB)
			{
				return fn(itemA, itemB);
			}) != null;
		});
	}

	public static function difference<T>(a:Array<T>, b:Array<T>, fn:(a:T, b:T) -> Bool)
	{
		return Lambda.filter(a, function(itemA)
		{
			return Lambda.find(b, function(itemB)
			{
				return fn(itemA, itemB);
			}) == null;
		});
	}

	public static function findRemove<T>(a:Array<T>, fn:(a:T) -> Bool):Null<T>
	{
		var idx = a.findIdx(fn);
		if (idx >= 0)
		{
			var e = a.splice(idx, 1);
			return e[0];
		}
		return null;
	}
}
