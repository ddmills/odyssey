package data.storylines;

abstract class StoryEffect
{
	public function new() {}

	public abstract function apply(storyline:Storyline):Void;
}
