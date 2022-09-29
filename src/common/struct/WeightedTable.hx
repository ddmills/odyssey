package common.struct;

import hxd.Rand;

typedef WeightedTableRow<T> =
{
	weight:Int,
	value:T,
}

enum TableCombineMethod
{
	MAX;
	MIN;
	SUM;
	OVERWRITE;
	EXISTING;
}

class WeightedTable<T>
{
	var rows:Array<WeightedTableRow<T>> = [];
	var sum(get, never):Int;

	public function new() {}

	public function pick(r:Rand):Null<T>
	{
		var n = r.random(sum);
		var currentW = 0;

		var picked = rows.find((row) ->
		{
			currentW += row.weight;

			return currentW >= n;
		});

		if (picked != null)
		{
			return picked.value;
		}

		return null;
	}

	public function reset()
	{
		rows = [];
	}

	public function get(value:T):Null<WeightedTableRow<T>>
	{
		return rows.find((row) -> row.value == value);
	}

	public function add(value:T, weight:Int, method:TableCombineMethod = MAX)
	{
		var row = get(value);

		if (row.isNull())
		{
			rows.push({
				weight: weight,
				value: value,
			});
		}
		else
		{
			row.weight = switch method
			{
				case MAX: Math.max(row.weight, weight).floor();
				case MIN: Math.min(row.weight, weight).floor();
				case SUM: row.weight + weight;
				case OVERWRITE: weight;
				case EXISTING: row.weight;
			}
		}
	}

	public function remove(value:T):Bool
	{
		return rows.findRemove((row) -> row.value == value);
	}

	public function chance(value:T):Float
	{
		var row = get(value);

		if (row.isNull())
		{
			return 0;
		}

		return row.weight / sum;
	}

	static function Combine<V>(tables:Array<WeightedTable<V>>, method:TableCombineMethod = SUM):WeightedTable<V>
	{
		var table = new WeightedTable<V>();
		for (t in tables)
		{
			for (row in t.rows)
			{
				table.add(row.value, row.weight, method);
			}
		}
		return table;
	}

	inline function get_sum():Int
	{
		return rows.sum((row) -> row.weight).floor();
	}
}
