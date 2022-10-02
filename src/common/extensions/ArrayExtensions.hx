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

	public static function findRemove<T>(a:Array<T>, fn:(a:T) -> Bool):Bool
	{
		var idx = a.findIdx(fn);
		if (idx >= 0)
		{
			a.splice(idx, 1);
			return true;
		}
		return false;
	}

	public static function last<T>(a:Array<T>):Null<T>
	{
		return a.length == 0 ? null : a[a.length - 1];
	}
}
