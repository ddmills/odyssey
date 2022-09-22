package domain.data.liquids;

import data.ColorKeys;

class LiquidWater extends Liquid
{
	public function new()
	{
		super(LIQUID_WATER, 'water', ColorKeys.C_BLUE_3, ColorKeys.C_BLUE_2);
	}
}
