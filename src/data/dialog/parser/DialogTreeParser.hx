package data.dialog.parser;

class DialogTreeParser
{
	public static function FromJson(json:Dynamic):DialogTree
	{
		var dialogs = json.dialogs.map((j) -> ({
			helper: j.helper,
			isDefault: j.isDefault == true ? true : false,
			say: j.say,
			options: j.options == null ? [] : j.options,
		}));

		return {
			dialogs: dialogs,
		};
	}
}
