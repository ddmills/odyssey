package data.dialog;

import common.struct.DataRegistry;
import data.dialog.parser.DialogExtraOptionParser;
import data.dialog.parser.DialogTreeParser;

class DialogTrees
{
	private static var dialog:DataRegistry<DialogTreeType, DialogTree>;
	private static var options:DataRegistry<DialogExtraOptionType, DialogExtraOptions>;

	public static function Init()
	{
		dialog = new DataRegistry();
		options = new DataRegistry();

		var villagerJson = hxd.Res.stories.dialog.dialog_villager.toJson();
		var villager = DialogTreeParser.FromJson(villagerJson);
		dialog.register(DIALOG_VILLAGER, villager);

		var wolfJson = hxd.Res.stories.dialog.dialog_wolf.toJson();
		var wolf = DialogTreeParser.FromJson(wolfJson);
		dialog.register(DIALOG_WOLF, wolf);

		var rumorsJson = hxd.Res.stories.dialog.options_rumors.toJson();
		var rumors = DialogExtraOptionParser.FromJson(rumorsJson);
		options.register(DIALOG_OPTION_RUMORS, rumors);
	}

	public static function Get(tree:DialogTreeType):DialogTree
	{
		return dialog.get(tree);
	}

	public static function GetExtraOptions(type:DialogExtraOptionType):DialogExtraOptions
	{
		return options.get(type);
	}
}
