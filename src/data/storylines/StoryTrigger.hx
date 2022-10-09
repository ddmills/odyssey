package data.storylines;

class StoryTrigger
{
	public var key:String;
	public var effects:Array<StoryEffect>;
	public var once:Bool;

	public function new(key:String, effects:Array<StoryEffect>, ?once:Bool)
	{
		this.key = key;
		this.effects = effects;
		this.once = once.or(true);
	}

	public function check(storyline:Storyline)
	{
		return false;
	}
}
