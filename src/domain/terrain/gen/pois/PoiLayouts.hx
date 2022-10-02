package domain.terrain.gen.pois;

import common.struct.DataRegistry;
import data.PoiLayoutType;

class PoiLayouts
{
	private static var layouts:DataRegistry<PoiLayoutType, PoiLayout>;

	public static function Init()
	{
		layouts = new DataRegistry();
		layouts.register(POI_LAYOUT_SCATTERED, new PoiLayoutScattered());
	}

	public static function Get(poiLayoutType:PoiLayoutType):PoiLayout
	{
		return layouts.get(poiLayoutType);
	}
}
