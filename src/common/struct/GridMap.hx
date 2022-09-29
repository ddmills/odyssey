package common.struct;

import common.struct.Grid.GridItem;
import common.struct.Grid.GridIterator;
import common.struct.Grid.GridSave;

@:generic class GridMap<T:(String)>
{
	var hash:Map<T, Int>;
	var grid:Grid<Array<T>>;

	public var width(default, null):Int;
	public var height(default, null):Int;
	public var size(get, null):Int;

	function get_size()
	{
		return height * width;
	}

	public function new(width:Int = 128, height:Int = 128)
	{
		grid = new Grid(width, height);
		grid.fillFn((idx:Int) -> new Array());
		hash = new Map();
	}

	public inline function idx(x:Int, y:Int)
	{
		return grid.idx(x, y);
	}

	public function coord(idx:Int)
	{
		return grid.coord(idx);
	}

	public inline function getAt(idx:Int):Array<T>
	{
		return grid.getAt(idx).copy();
	}

	public function get(x:Int, y:Int):Array<T>
	{
		var res = grid.get(x, y);

		if (res.isNull())
		{
			return new Array<T>();
		}

		return res.copy();
	}

	public function set(x:Int, y:Int, value:T)
	{
		var idx = idx(x, y);
		setIdx(idx, value);
	}

	public function setIdx(idx:Int, value:T)
	{
		remove(value);
		grid.getAt(idx).push(value);
		hash.set(value, idx);
	}

	public function has(value:T)
	{
		return hash.exists(value);
	}

	public function getIdx(id:T):Null<Int>
	{
		var idx = hash.get(id);
		if (idx.isNull())
		{
			return null;
		}
		return idx;
	}

	public function getPosition(id:T):Null<IntPoint>
	{
		var idx = hash.get(id);
		if (idx.isNull())
		{
			return null;
		}
		var coord = coord(idx);

		return new IntPoint(coord.x, coord.y);
	}

	public function remove(value:T):Bool
	{
		if (!has(value))
		{
			return false;
		}
		var idx = getIdx(value);
		hash.remove(value);
		grid.getAt(idx).remove(value);
		return true;
	}

	public function clear()
	{
		grid.clear();
		hash.clear();
	}

	public function save<V>(fn:(Array<T>) -> V):GridSave<V>
	{
		return {
			width: width,
			height: height,
			data: grid.map((item:GridItem<Array<T>>) -> fn(item.value))
		}
	}

	public function load<V>(save:GridSave<V>, fn:(V) -> Array<T>)
	{
		width = save.width;
		height = save.height;
		for (i => d in save.data)
		{
			var values = fn(d);
			for (v in values)
			{
				setIdx(i, v);
			}
		}
	}

	public function iterator()
	{
		return new GridIterator(grid);
	}
}
