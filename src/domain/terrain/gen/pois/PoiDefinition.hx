package domain.terrain.gen.pois;

import data.PoiLayoutType;
import data.PoiType;
import domain.terrain.Overworld.RoomTemplate;
import domain.terrain.biomes.Biome.MapIconData;
import domain.terrain.gen.ZonePoi.PoiSize;

typedef PoiDefinition =
{
	var name:String;
	var size:PoiSize;
	var type:PoiType;
	var layout:PoiLayoutType;
	var rooms:Array<RoomTemplate>;
	var icon:MapIconData;
};
