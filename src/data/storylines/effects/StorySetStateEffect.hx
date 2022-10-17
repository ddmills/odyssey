package data.storylines.effects;

class StorySetStateEffect extends StoryEffect
{
	public function new()
	{
		super();
	}

	public function apply(storyline:Storyline) {}

	public static function FromJson(json:Dynamic):StorySetStateEffect
	{
		return new StorySetStateEffect();
	}
}
