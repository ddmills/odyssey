package domain.data.liquids;

import data.ColorKey;

class LiquidBlood extends Liquid
{
	public function new()
	{
		super(LIQUID_BLOOD, 'blood', C_RED, C_RED);
	}
}
