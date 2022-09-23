package domain.data.liquids;

import data.ColorKeys;

class LiquidWhaleOil extends Liquid
{
	public function new()
	{
		super(LIQUID_WHALE_OIL, 'whale oil', ColorKeys.C_PURPLE_1, ColorKeys.C_PURPLE_2);
	}
}
