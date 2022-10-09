package data.storylines;

import data.storylines.parser.StoryParser;

class Stories
{
	private static var stories:Map<String, Story>;

	public static function Init()
	{
		stories = new Map();

		var wolfJson = hxd.Res.stories.wolf_json.toJson();
		var wolf = StoryParser.FromJson(wolfJson);

		stories.set(wolf.id, wolf);
	}

	public static function Get(id:String):Null<Story>
	{
		return stories.get(id);
	}
}
