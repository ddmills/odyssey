package data.core;

class ColorPalette
{
	public static var colors:Map<ColorKey, Int> = [];

	public function new()
	{
		colors = [];
	}

	public function setColor(key:ColorKey, value:Int)
	{
		colors.set(key, value);
	}

	public function getColor(key:ColorKey):Int
	{
		var value = colors.get(key);
		return value.isNull() ? 0xFF00C3 : value;
	}
}
