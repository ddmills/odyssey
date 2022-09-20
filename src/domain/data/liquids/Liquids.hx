package domain.data.liquids;

import common.struct.DataRegistry;
import data.LiquidType;

class Liquids
{
	static var registry:DataRegistry<LiquidType, Liquid>;

	public static function Init()
	{
		registry = new DataRegistry();

		registry.register(LIQUID_WATER, new LiquidWater());
		registry.register(LIQUID_BLOOD, new LiquidBlood());
		registry.register(LIQUID_HONEY, new LiquidHoney());
		registry.register(LIQUID_WHISKEY, new LiquidWhiskey());
		registry.register(LIQUID_WHALE_OIL, new LiquidWhaleOil());
	}

	public static function get(liquidType:LiquidType)
	{
		return registry.get(liquidType);
	}
}
