package data.dialog;

import data.dialog.Dialog;
import data.dialog.DialogCondition;
import data.dialog.parser.DialogConditionParser;

typedef DialogOption =
{
	option:String,
	dialogs:Array<Dialog>,
	conditions:Array<DialogCondition>,
	?detail:String,
};

class DialogOptionParser
{
	public static function FromJson(json:Dynamic):DialogOption
	{
		var dialogs = DialogParser.FromJsonArray(json.dialogs);
		var conditions = DialogConditionParser.FromJsonArray(json.conditions);

		return {
			option: json.option,
			dialogs: dialogs,
			conditions: conditions,
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
