package data.storylines.requirements;

import data.BiomeType;
import data.PoiType;
import haxe.EnumTools;

typedef StoryZoneDistanceRequirement =
{
	source:String,
	?min:Int,
	?max:Int,
}

typedef StoryZoneRequirementParams =
{
	?biomes:Array<BiomeType>,
	?poiType:PoiType,
	?distance:StoryZoneDistanceRequirement,
};

class StoryZoneRequirement extends StoryRequirement
{
	public var params:StoryZoneRequirementParams;

	public function new(params:StoryZoneRequirementParams)
	{
		super();
		this.params = params;
	}

	public static function FromJson(json:Dynamic):StoryZoneRequirement
	{
		var poiType = json.poiType == null ? null : EnumTools.createByName(PoiType, json.poiType);
		var biomes:Array<BiomeType> = null;
		var distance:StoryZoneDistanceRequirement = null;

		if (json.biomes != null)
		{
			biomes = json.biomes.map((b) ->
			{
				return EnumTools.createByName(BiomeType, b);
			});
		}

		if (json.distance != null)
		{
			distance = {
				min: json.distance.min,
				max: json.distance.max,
				source: json.distance.source,
			};
		}

		var r = new StoryZoneRequirement({
			biomes: biomes,
			poiType: poiType,
			distance: json.distance,
		});

		return r;
	}
}
