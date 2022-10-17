package data.dialog.parser;

import data.dialog.Dialog.DialogParser;

class DialogTreeParser
{
	public static function FromJson(json:Dynamic):DialogTree
	{
		var dialogs = DialogParser.FromJsonArray(json.dialogs);

		return {
			dialogs: dialogs,
		};
	}
}
