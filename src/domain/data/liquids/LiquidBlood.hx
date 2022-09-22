package domain.data.liquids;

import data.ColorKeys;

class LiquidBlood extends Liquid
{
	public function new()
	{
		super(LIQUID_BLOOD, 'blood', ColorKeys.C_RED_1, ColorKeys.C_PINK_2);
	}
}
