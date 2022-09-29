package common.extensions;

class MapExtensions
{
	static public inline function values<K, V>(m:Map<K, V>):Array<V>
	{
		return [for (k in m) k];
	}
}
