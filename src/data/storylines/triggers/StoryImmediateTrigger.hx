package data.storylines.triggers;

import data.storylines.StoryEffect;
import data.storylines.parser.StoryEffectParser;

typedef StoryImmediateTriggerParams =
{
	var key:String;
	var effects:Array<StoryEffect>;
	var once:Null<Bool>;
};

class StoryImmediateTrigger extends StoryTrigger
{
	public var params:StoryImmediateTriggerParams;

	public function new(params:StoryImmediateTriggerParams)
	{
		super(params.key, params.effects, params.once);
		this.params = params;
	}

	public override function check(storyline:Storyline)
	{
		var data = storyline.getTriggerData(key);

		if (data == null)
		{
			storyline.setTriggerData(key, true);

			return true;
		}

		return false;
	}

	public static function FromJson(json:Dynamic):StoryImmediateTrigger
	{
		var effects = json.effects.map((s) ->
		{
			return StoryEffectParser.FromJson(s);
		});

		return new StoryImmediateTrigger({
			key: json.key,
			effects: effects,
			once: json.once,
		});
	}
}
