package data.storylines.variables;

typedef StoryEntityVariableParams =
{
	var key:String;
}

class StoryEntityVariable extends StoryVariable
{
	public function new(params:StoryEntityVariableParams)
	{
		super(params.key);
	}

	public static function FromJson(json:Dynamic):StoryEntityVariable
	{
		return new StoryEntityVariable({
			key: json.key,
		});
	}
}
