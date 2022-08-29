package common.struct;

@:generic class Queue<T>
{
	var items:Array<T>;

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
		return items.push(value);
	}

	public function dequeue():Null<T>
	{
		return items.shift();
	}

	public function clear()
	{
		items = new Array();
	}
}
