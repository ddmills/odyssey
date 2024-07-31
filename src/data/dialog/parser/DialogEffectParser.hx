package data.dialog.parser;

import data.dialog.effects.DialogHealEffect;
import data.dialog.effects.DialogRelationEffect;

class DialogEffectParser
{
	public static function FromJson(json:Dynamic):DialogEffect
	{
		return switch json.type
		{
			case DialogEffectType.EFFECT_RELATION: DialogRelationEffect.FromJson(json);
			case DialogEffectType.EFFECT_HEAL: DialogHealEffect.FromJson(json);
			case _: null;
		}
	}

	public static function FromJsonArray(json:Dynamic):Array<DialogEffect>
	{
		return json == null ? [] : json.map(FromJson);
	}
}
