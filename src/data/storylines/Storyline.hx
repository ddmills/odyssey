package data.storylines;

import common.struct.Set;
import core.Game;
import domain.terrain.Zone;
import ecs.Entity;
import hxd.Rand;

typedef StorylineSave =
{
	storyId:String,
	triggerData:Map<String, Dynamic>,
	variables:Map<String, Dynamic>,
	triggered:Set<String>,
	seed:Int,
};

class Storyline
{
	private var triggerData:Map<String, Dynamic>;
	private var variables:Map<String, Dynamic>;
	private var triggered:Set<String>;

	public var rand:Rand;
	public var story(default, null):Story;

	public function save():StorylineSave
	{
		return {
			triggerData: triggerData,
			variables: variables,
			triggered: triggered,
			storyId: story.id,
			seed: rand.getSeed(),
		}
	}

	public function initialize():Bool
	{
		// TODO: add attempts
		for (variable in story.params.state)
		{
			if (!variable.initialize(this))
			{
				return false;
			}
		}

		return true;
	}

	public function update()
	{
		for (trigger in story.params.triggers)
		{
			if (trigger.once && triggered.has(trigger.key))
			{
				continue;
			}

			if (trigger.check(this))
			{
				trace('apply', trigger.key);
				for (effect in trigger.effects)
				{
					effect.apply(this);
				}
				triggered.add(trigger.key);
			}
		}
	}

	public function getZoneVariable(key:String):Null<Zone>
	{
		var id = variables.get(key);
		if (id == null)
		{
			return null;
		}

		return Game.instance.world.zones.getZoneById(id);
	}

	public function setZoneVariable(key:String, zone:Zone)
	{
		if (zone == null)
		{
			variables.remove(key);
		}

		variables.set(key, zone.zoneId);
	}

	public function getEntityVariable(key:String):Null<Entity>
	{
		var id = variables.get(key);
		if (id == null)
		{
			return null;
		}

		return Game.instance.registry.getEntity(id);
	}

	public function setEntityVariable(key:String, entity:Entity)
	{
		if (entity == null)
		{
			variables.remove(key);
		}

		variables.set(key, entity.id);
	}

	public function getTriggerData<T>(key:String)
	{
		return cast triggerData.get(key);
	}

	public function setTriggerData<T>(key:String, value:T)
	{
		triggerData.set(key, value);
	}

	public static function Load(data:StorylineSave):Storyline
	{
		var story = Stories.Get(data.storyId);
		var storyline = new Storyline(story, data.seed);
		storyline.triggerData = data.triggerData;
		storyline.variables = data.variables;
		storyline.triggered = data.triggered;

		return storyline;
	}

	public function new(story:Story, seed:Int)
	{
		this.story = story;
		triggerData = [];
		triggered = new Set();
		variables = [];
		rand = new Rand(seed);
	}
}
