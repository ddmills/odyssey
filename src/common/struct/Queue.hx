package common.struct;

@:generic class Queue<T>
{
	var items:Array<T>;
	var _maxLength:Null<Int>;

	public var maxLength(get, set):Null<Int>;
	public var isEmpty(get, never):Bool;
	public var length(get, never):Int;

	public function new()
	{
		items = new Array();
	}

	function get_isEmpty():Bool
	{
		return items.length == 0;
	}

	function get_length():Int
	{
		return items.length;
	}

	public function peek():Null<T>
	{
		return isEmpty ? null : items[0];
	}

	public function enqueue(value:T):Int
	{
		if (maxLength != null)
		{
			if (length < maxLength)
			{
				return items.push(value);
			}
			return -1;
		}
		else
		{
			return items.push(value);
		}
	}

	public function dequeue():Null<T>
	{
		return items.shift();
	}

	public function clear()
	{
		items = new Array();
	}

	function get_maxLength():Null<Int>
	{
		return _maxLength;
	}

	function set_maxLength(value:Null<Int>):Null<Int>
	{
		if (value != null && value < length)
		{
			items.splice(value - 1, length);
		}
		return _maxLength = value;
	}
}
