package data.dialog;

import data.dialog.Dialog;
import data.dialog.DialogCondition;
import data.dialog.DialogEffect;
import data.dialog.parser.DialogConditionParser;
import data.dialog.parser.DialogEffectParser;

typedef DialogOption =
{
	option:String,
	dialogs:Array<Dialog>,
	conditions:Array<DialogCondition>,
	effects:Array<DialogEffect>,
	isEnd:Bool,
	?detail:String,
};

class DialogOptionParser
{
	public static function FromJson(json:Dynamic):DialogOption
	{
		var dialogs = DialogParser.FromJsonArray(json.dialogs);
		var conditions = DialogConditionParser.FromJsonArray(json.conditions);
		var effects = DialogEffectParser.FromJsonArray(json.effects);
		var isEnd = json.isEnd == null ? false : json.isEnd;

		return {
			option: json.option,
			dialogs: dialogs,
			conditions: conditions,
			effects: effects,
			isEnd: isEnd,
		}
	}

	public static function FromJsonArray(json:Dynamic):Array<DialogOption>
	{
		if (json == null)
		{
			return [];
		}

		return json.map(FromJson);
	}
}
