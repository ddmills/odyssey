package data.storylines.parser;

import data.storylines.triggers.StoryEntityDeathTrigger;
import data.storylines.triggers.StoryImmediateTrigger;

class StoryTriggerParser
{
	public static function FromJson(json:Dynamic):StoryTrigger
	{
		return switch json.type
		{
			case StoryTriggerType.ENTITY_DEATH: StoryEntityDeathTrigger.FromJson(json);
			case StoryTriggerType.IMMEDIATE: StoryImmediateTrigger.FromJson(json);
			case _: null;
		}
	}
}
