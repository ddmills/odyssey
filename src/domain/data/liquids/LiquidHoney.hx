package domain.data.liquids;

import data.ColorKeys;

class LiquidHoney extends Liquid
{
	public function new()
	{
		super(LIQUID_HONEY, 'honey', ColorKeys.C_YELLOW_2, ColorKeys.C_ORANGE_1);
	}
}
