package data.storylines.parser;

class StoryParser
{
	public static function FromJson(json:Dynamic):Story
	{
		var state = json.state.map((s) ->
		{
			return StoryVariableParser.FromJson(s);
		});

		var triggers = json.triggers.map((s) ->
		{
			return StoryTriggerParser.FromJson(s);
		});

		return new Story({
			id: json.id,
			name: json.name,
			state: state,
			triggers: triggers
		});
	}
}
