package data.storylines.variables;

typedef StoryBoolVariableParams =
{
	var key:String;
}

class StoryBoolVariable extends StoryVariable
{
	public function new(params:StoryBoolVariableParams)
	{
		super(params.key);
	}

	public static function FromJson(json:Dynamic):StoryBoolVariable
	{
		return new StoryBoolVariable({
			key: json.key,
		});
	}
}
