package common.struct;

@:generic class Set<T>
{
	public var items:Array<T>;

	public var isEmpty(get, never):Bool;
	public var length(get, never):Int;

	private var comparator:(a:T, b:T) -> Bool = (a, b) -> a == b;

	public function new(comparator:(a:T, b:T) -> Bool = null)
	{
		if (comparator != null)
		{
			this.comparator = comparator;
		}

		items = new Array();
	}

	inline public function has(v:T):Bool
	{
		return items.exists(x -> comparator(x, v));
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
		return isEmpty ? null : items.pop();
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

	public function asArray()
	{
		return items;
	}
}
