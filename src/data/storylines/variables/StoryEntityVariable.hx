package data.storylines.variables;

typedef StoryEntityVariableParams =
{
	key:String,
	isParameter:Bool,
}

class StoryEntityVariable extends StoryVariable
{
	public function new(params:StoryEntityVariableParams)
	{
		super(params.key, params.isParameter);
	}

	public static function FromJson(json:Dynamic):StoryEntityVariable
	{
		return new StoryEntityVariable({
			key: json.key,
			isParameter: json.isParameter,
		});
	}
}
