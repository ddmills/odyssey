package data.dialog;

import data.dialog.DialogOption;

typedef Dialog =
{
	?helper:String,
	isDefault:Bool,
	say:String,
	options:Array<DialogOption>,
};
