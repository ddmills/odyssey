package data.storylines;

import data.storylines.StoryTrigger;
import data.storylines.StoryVariable;

typedef StoryParams =
{
	id:String,
	name:String,
	state:Array<StoryVariable>,
	triggers:Array<StoryTrigger>,
}

class Story
{
	public var params:StoryParams;
	public var name(get, never):String;
	public var id(get, never):String;

	public function new(params:StoryParams)
	{
		this.params = params;
	}

	inline function get_name():String
	{
		return params.name;
	}

	inline function get_id():String
	{
		return params.id;
	}
}
