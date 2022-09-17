package common.struct;

@:generic class Set<T>
{
	private var items:Array<T>;

	public var isEmpty(get, never):Bool;
	public var length(get, never):Int;

	public function new()
	{
		items = new Array();
	}

	inline public function has(v:T):Bool
	{
		return items.has(v);
	}

	public function add(v:T):Int
	{
		if (!has(v))
		{
			items.push(v);
		}

		return length;
	}

	public function remove(v:T):Bool
	{
		return items.remove(v);
	}

	public function pop():Null<T>
	{
		return isEmpty ? null : items.shift();
	}

	inline function get_isEmpty():Bool
	{
		return items.length == 0;
	}

	inline function get_length():Int
	{
		return items.length;
	}

	public function iterator()
	{
		return items.iterator();
	}
}
