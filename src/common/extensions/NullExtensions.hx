package common.extensions;

class NullExtensions
{
	static public inline function or<T>(nullable:Null<T>, def:T):T
	{
		return nullable == null ? def : nullable;
	}

	static public inline function orGet<T>(nullable:Null<T>, fn:() -> T):T
	{
		return nullable == null ? fn() : nullable;
	}

	static public inline function isNull<T>(nullable:Null<T>):Bool
	{
		return nullable == null;
	}

	static public inline function hasValue<T>(nullable:Null<T>):Bool
	{
		return nullable != null;
	}
}
