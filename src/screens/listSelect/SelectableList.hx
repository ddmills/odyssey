package screens.listSelect;

typedef SelectableListItem<T> =
{
	item:T,
	idx:Int,
	isSelected:Bool,
}

@:generic class SelectableList<T>
{
	var items:Array<T>;
	var _maxLength:Null<Int>;
	var idx:Int;

	public var isEmpty(get, never):Bool;
	public var length(get, never):Int;
	public var selected(get, never):T;
	public var data(get, never):Array<SelectableListItem<T>>;

	public function new(items:Array<T>, idx = 0)
	{
		this.items = items;
		this.idx = idx;
	}

	function get_isEmpty():Bool
	{
		return items.length == 0;
	}

	function get_length():Int
	{
		return items.length;
	}

	public function setItems(values:Array<T>)
	{
		items = values;
		selectIdx(idx);
	}

	public function dequeue():Null<T>
	{
		return items.shift();
	}

	function get_selected():T
	{
		return items[idx];
	}

	public function selectIdx(value:Int)
	{
		// idx = Math.min(Math.max(value, 0), length - 1).floor();
		idx = value;
	}

	public function up()
	{
		idx--;

		if (idx < 0)
		{
			idx = items.length - 1;
		}
	}

	public function down()
	{
		idx++;

		if (idx >= items.length)
		{
			idx = 0;
		}
	}

	function get_data():Array<SelectableListItem<T>>
	{
		var i = 0;
		return items.map((item:T) -> ({
			item: item,
			idx: i,
			isSelected: i++ == idx
		}));
	}

	public function iterator():Iterator<SelectableListItem<T>>
	{
		return data.iterator();
	}
}
