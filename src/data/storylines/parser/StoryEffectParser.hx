package data.storylines.parser;

import data.storylines.effects.StoryEntitySpawnEffect;
import data.storylines.effects.StorySetStateEffect;

class StoryEffectParser
{
	public static function FromJson(json:Dynamic):StoryEffect
	{
		return switch json.type
		{
			case StoryEffectType.ENTITY_SPAWN: StoryEntitySpawnEffect.FromJson(json);
			case StoryEffectType.SET_STATE: StorySetStateEffect.FromJson(json);
			case _: null;
		}
	}
}
