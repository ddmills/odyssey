package data.storylines.parser;

import data.storylines.requirements.StoryZoneRequirement;

class StoryRequirementParser
{
	public static function FromJson(json:Dynamic):StoryRequirement
	{
		return switch json.type
		{
			case StoryRequirementType.ZONE: StoryZoneRequirement.FromJson(json);
			case _: null;
		}
	}
}
