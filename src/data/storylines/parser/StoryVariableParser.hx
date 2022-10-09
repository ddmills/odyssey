package data.storylines.parser;

import data.storylines.variables.StoryBoolVariable;
import data.storylines.variables.StoryEntityVariable;
import data.storylines.variables.StoryZoneVariable;

class StoryVariableParser
{
	public static function FromJson(json:Dynamic):StoryVariable
	{
		return switch json.type
		{
			case StoryVariableType.ZONE: StoryZoneVariable.FromJson(json);
			case StoryVariableType.BOOL: StoryBoolVariable.FromJson(json);
			case StoryVariableType.ENTITY: StoryEntityVariable.FromJson(json);
			case _: null;
		}
	}
}
