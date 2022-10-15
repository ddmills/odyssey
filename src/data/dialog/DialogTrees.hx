package data.dialog;

import common.struct.DataRegistry;
import data.dialog.parser.DialogTreeParser;

class DialogTrees
{
	private static var dialog:DataRegistry<DialogTreeType, DialogTree>;

	public static function Init()
	{
		dialog = new DataRegistry();

		var villagerJson = hxd.Res.stories.dialog.dialog_villager.toJson();
		var villager = DialogTreeParser.FromJson(villagerJson);

		dialog.register(DIALOG_VILLAGER, villager);
	}

	public static function Get(tree:DialogTreeType):DialogTree
	{
		return dialog.get(tree);
	}
}
