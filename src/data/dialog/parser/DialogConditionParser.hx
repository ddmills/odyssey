package data.dialog.parser;

import data.dialog.conditions.DialogRelationCondition;

class DialogConditionParser
{
	public static function FromJson(json:Dynamic):DialogCondition
	{
		return switch json.type
		{
			case DialogConditionType.CONDITION_RELATION: DialogRelationCondition.FromJson(json);
			case _: null;
		}
	}

	public static function FromJsonArray(json:Dynamic):Array<DialogCondition>
	{
		return json == null ? [] : json.map(FromJson);
	}
}
