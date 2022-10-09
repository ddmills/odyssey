package data.storylines.effects;

import domain.prefabs.Spawner;

class StorySetStateEffect extends StoryEffect
{
	public function new()
	{
		super();
	}

	public override function apply(storyline:Storyline) {}

	public static function FromJson(json:Dynamic):StorySetStateEffect
	{
		return new StorySetStateEffect();
	}
}
