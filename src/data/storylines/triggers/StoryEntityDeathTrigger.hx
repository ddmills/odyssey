package data.storylines.triggers;

import data.storylines.StoryEffect;
import data.storylines.parser.StoryEffectParser;
import domain.components.IsDead;

typedef StoryEntityDeathTriggerParams =
{
	var key:String;
	var target:String;
	var effects:Array<StoryEffect>;
	var once:Null<Bool>;
};

class StoryEntityDeathTrigger extends StoryTrigger
{
	public var params:StoryEntityDeathTriggerParams;

	public function new(params:StoryEntityDeathTriggerParams)
	{
		super(params.key, params.effects, params.once);
		this.params = params;
	}

	override function check(storyline:Storyline):Bool
	{
		var entity = storyline.getEntityVariable(params.target);

		return entity == null || entity.has(IsDead);
	}

	public static function FromJson(json:Dynamic):StoryEntityDeathTrigger
	{
		var effects = json.effects.map((s) -> StoryEffectParser.FromJson(s));

		return new StoryEntityDeathTrigger({
			key: json.key,
			target: json.target,
			effects: effects,
			once: json.once,
		});
	}
}
