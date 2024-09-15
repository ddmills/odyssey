package data.storylines.variables;

import common.algorithm.Distance;
import core.Game;
import data.storylines.requirements.StoryZoneRequirement;

typedef StoryZoneVariableParams =
{
	var key:String;
	var isParameter:Bool;
	var requirements:StoryZoneRequirement;
}

class StoryZoneVariable extends StoryVariable
{
	var params:StoryZoneVariableParams;

	public function new(params:StoryZoneVariableParams)
	{
		super(params.key, params.isParameter);
		this.params = params;
	}

	public static function FromJson(json:Dynamic):StoryZoneVariable
	{
		var requirements:StoryZoneRequirement = null;

		if (json.requirements != null)
		{
			requirements = StoryZoneRequirement.FromJson(json.requirements);
		}

		return new StoryZoneVariable({
			key: json.key,
			isParameter: json.isParameter,
			requirements: requirements,
		});
	}

	public override function tryPopulate(storyline:Storyline):Bool
	{
		if (params.requirements == null)
		{
			return true;
		}

		var req = params.requirements.params;

		// find all eligible zones
		var eligible = Game.instance.world.map.zones.zones.filterMap((z) ->
		{
			var zone = z.value;

			if (req.poiType != null)
			{
				if (!(zone.poi != null && zone.poi.type == req.poiType))
				{
					return {
						value: zone,
						filter: false,
					};
				}
			}

			if (req.biomes != null)
			{
				if (!req.biomes.contains(zone.primaryBiome))
				{
					return {
						value: zone,
						filter: false,
					};
				}
			}

			if (req.distance != null)
			{
				var source = storyline.getZoneVariable(req.distance.source);
				if (source == null)
				{
					return {
						value: zone,
						filter: false,
					};
				}

				var distance = Distance.Chebyshev(source.zonePos, zone.zonePos);
				var min = req.distance.min.or(0);
				var max = req.distance.max.or(2000);
				if (distance < min || distance >= max)
				{
					return {
						value: zone,
						filter: false,
					};
				}
			}

			return {
				value: zone,
				filter: true,
			};
		});

		if (eligible.length == 0)
		{
			return false;
		}

		var zone = storyline.rand.pick(eligible);

		storyline.setZoneVariable(params.key, zone);

		return true;
	}
}
