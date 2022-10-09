package domain.systems;

import core.Frame;
import data.storylines.Stories;
import data.storylines.Storyline;
import ecs.System;

class StorylineSystem extends System
{
	private var active:Array<Storyline>;

	public function new()
	{
		active = [];
	}

	public function addStoryline(id:String)
	{
		var story = Stories.Get(id);

		var storyline = new Storyline(story);

		active.push(storyline);

		return storyline;
	}

	override function update(frame:Frame)
	{
		for (storyline in active)
		{
			storyline.update();
		}
	}
}
