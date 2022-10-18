package data.dialog;

import data.dialog.DialogCondition;
import data.dialog.DialogEffect;
import data.dialog.DialogOption;
import data.dialog.parser.DialogConditionParser;
import data.dialog.parser.DialogEffectParser;

typedef Dialog =
{
	?helper:String,
	isDefault:Bool,
	say:String,
	options:Array<DialogOption>,
	conditions:Array<DialogCondition>,
	effects:Array<DialogEffect>,
};

class DialogParser
{
	public static function FromJson(json:Dynamic):Dialog
	{
		var options = DialogOptionParser.FromJsonArray(json.options);
		var conditions = DialogConditionParser.FromJsonArray(json.conditions);
		var effects = DialogEffectParser.FromJsonArray(json.effects);
		var isDefault = json.isDefault == true ? true : false;

		return {
			say: json.say,
			helper: json.helper,
			isDefault: isDefault,
			options: options,
			conditions: conditions,
			effects: effects,
		};
	}

	public static function FromJsonArray(json:Dynamic):Array<Dialog>
	{
		if (json == null)
		{
			return [];
		}

		return json.map(FromJson);
	}
}
