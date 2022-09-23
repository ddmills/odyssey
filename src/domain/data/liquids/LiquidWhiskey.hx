package domain.data.liquids;

import data.ColorKeys;

class LiquidWhiskey extends Liquid
{
	public function new()
	{
		super(LIQUID_WHISKEY, 'whiskey', ColorKeys.C_WHITE_1, ColorKeys.C_YELLOW_2);
	}
}
