package data.dialog.parser;

import data.dialog.DialogOption.DialogOptionParser;

class DialogExtraOptionParser
{
	public static function FromJson(json:Dynamic):DialogExtraOptions
	{
		var options = DialogOptionParser.FromJsonArray(json.options);

		return {
			options: options,
		};
	}
}
