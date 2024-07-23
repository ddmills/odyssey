package data;

import core.Game;

enum abstract ColorKey(String) to String from String
{
	var C_WHITE = 'C_WHITE';
	var C_BLACK = 'C_BLACK';
	var C_GRAY_1 = 'C_GRAY_1';
	var C_GRAY_2 = 'C_GRAY_2';
	var C_GRAY_3 = 'C_GRAY_3';
	var C_GRAY_4 = 'C_GRAY_4';
	var C_GRAY_5 = 'C_GRAY_5';
	var C_GRAY_6 = 'C_GRAY_6';
	var C_GREEN_0 = 'C_GREEN_0';
	var C_GREEN_1 = 'C_GREEN_1';
	var C_GREEN_2 = 'C_GREEN_2';
	var C_GREEN_3 = 'C_GREEN_3';
	var C_GREEN_4 = 'C_GREEN_4';
	var C_GREEN_5 = 'C_GREEN_5';
	var C_BLUE_0 = 'C_BLUE_0';
	var C_BLUE_1 = 'C_BLUE_1';
	var C_BLUE_2 = 'C_BLUE_2';
	var C_BLUE_3 = 'C_BLUE_3';
	var C_BLUE_4 = 'C_BLUE_4';
	var C_BLUE_5 = 'C_BLUE_5';
	var C_PURPLE_0 = 'C_PURPLE_0';
	var C_PURPLE_1 = 'C_PURPLE_1';
	var C_PURPLE_2 = 'C_PURPLE_2';
	var C_PURPLE_3 = 'C_PURPLE_3';
	var C_PURPLE_4 = 'C_PURPLE_4';
	var C_PURPLE_5 = 'C_PURPLE_5';
	var C_RED_0 = 'C_RED_0';
	var C_RED_1 = 'C_RED_1';
	var C_RED_2 = 'C_RED_2';
	var C_RED_3 = 'C_RED_3';
	var C_RED_4 = 'C_RED_4';
	var C_RED_5 = 'C_RED_5';
	var C_YELLOW_0 = 'C_YELLOW_0';
	var C_YELLOW_1 = 'C_YELLOW_1';
	var C_YELLOW_2 = 'C_YELLOW_2';
	var C_YELLOW_3 = 'C_YELLOW_3';
	var C_YELLOW_4 = 'C_YELLOW_4';
	var C_YELLOW_5 = 'C_YELLOW_5';
	var C_CLEAR = 'C_CLEAR';

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
