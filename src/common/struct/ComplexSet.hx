package common.struct;

class ComplexSet<T> extends Set<T>
{
	private var comparator:(a:T, b:T) -> Bool = (a, b) -> a == b;

	public function new(comparator:(a:T, b:T) -> Bool = null)
	{
		super();

		if (comparator != null)
		{
			this.comparator = comparator;
		}
	}

	public override function has(v:T):Bool
	{
		return items.exists(x -> comparator(x, v));
	}
}
