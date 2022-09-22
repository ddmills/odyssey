package domain.data.liquids;

import data.ColorKeys;
import h3d.shader.ColorKey;

class LiquidWhiskey extends Liquid
{
	public function new()
	{
		super(LIQUID_WHISKEY, 'whiskey', ColorKeys.C_ORANGE_1, ColorKeys.C_YELLOW_2);
	}
}
