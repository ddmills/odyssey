package domain.systems;

import core.Frame;
import data.storylines.Stories;
import data.storylines.Storyline;
import ecs.System;

typedef StorylineSystemSave =
{
	active:Array<StorylineSave>,
}

class StorylineSystem extends System
{
	private var active:Array<Storyline>;

	public function new()
	{
		active = [];
	}

	public function save():StorylineSystemSave
	{
		return {
			active: active.map((s) -> s.save()),
		};
	}

	public function Load(data:StorylineSystemSave)
	{
		this.active = data.active.map((d) -> Storyline.Load(d));
	}

	public function addStoryline(id:String)
	{
		var story = Stories.Get(id);

		var storyline = new Storyline(story, 1);

		if (!storyline.initialize())
		{
			trace('COULD NOT INIT STORYLINE', storyline);
			return null;
		}

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
