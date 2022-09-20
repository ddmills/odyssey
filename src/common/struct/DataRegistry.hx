package common.struct;

class DataRegistry<K:EnumValue, V>
{
	private var data:Map<K, V>;

	public function new()
	{
		data = new Map();
	}

	public function get(key:K):V
	{
		return data.get(key);
	}

	public function register(key:K, value:V)
	{
		data.set(key, value);
	}
}
