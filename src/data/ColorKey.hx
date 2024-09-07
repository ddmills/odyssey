package data;

import core.Game;

enum abstract ColorKey(String) to String from String
{
	var C_BRIGHT_WHITE = 'C_BRIGHT_WHITE';
	var C_WHITE = 'C_WHITE';
	var C_BLACK = 'C_BLACK';

	var C_GRAY = 'C_GRAY';
	var C_LIGHT_GRAY = 'C_LIGHT_GRAY';
	var C_DARK_GRAY = 'C_DARK_GRAY';

	var C_BLUE = 'C_BLUE';
	var C_DARK_BLUE = 'C_DARK_BLUE';

	var C_GREEN = 'C_GREEN';
	var C_DARK_GREEN = 'C_DARK_GREEN';

	var C_RED = 'C_RED';
	var C_DARK_RED = 'C_DARK_RED';

	var C_YELLOW = 'C_YELLOW';
	var C_PURPLE = 'C_PURPLE';
	var C_DARK_PURPLE = 'C_DARK_PURPLE';
	var C_BROWN = 'C_BROWN';
	var C_DARK_BROWN = 'C_DARK_BROWN';
	var C_ORANGE = 'C_ORANGE';

	var C_WOOD = 'C_WOOD';
	var C_STONE = 'C_STONE';
	var C_FIRE_LIGHT = 'C_FIRE_LIGHT';
	var C_TEXT_PRIMARY = 'C_TEXT_PRIMARY';
	var C_CLEAR = 'C_CLEAR';
	var C_SHROUD = 'C_SHROUD';
	var C_TEXT_FOCUS = 'C_TEXT_FOCUS';

	@:to
	public function toInt():Int
	{
		return Game.instance.palette.getColor(this);
	}

	public function toHxdColor(a:Float = 1):h3d.Vector4
	{
		return Game.instance.palette.getColor(this).toHxdColor(a);
	}
}
