package data.storylines.variables;

typedef StoryPoiVariableParams =
{
	var key:String;
}

class StoryPoiVariable extends StoryVariable
{
	public function new(params:StoryPoiVariableParams)
	{
		super(params.key);
	}

	public static function FromJson(json:Dynamic):StoryPoiVariable
	{
		return new StoryPoiVariable({
			key: json.key,
		});
	}
}
