package data.storylines.variables;

typedef StoryBoolVariableParams =
{
	key:String,
	isParameter:Bool,
}

class StoryBoolVariable extends StoryVariable
{
	public function new(params:StoryBoolVariableParams)
	{
		super(params.key, params.isParameter);
	}

	public static function FromJson(json:Dynamic):StoryBoolVariable
	{
		return new StoryBoolVariable({
			key: json.key,
			isParameter: json.isParameter,
		});
	}
}
