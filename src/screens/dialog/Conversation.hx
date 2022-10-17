package screens.dialog;

import data.dialog.Dialog;
import data.dialog.DialogOption;
import ecs.Entity;
import hxd.Rand;

class Conversation
{
	var r:Rand;

	public var interactor:Entity;
	public var target:Entity;

	var current:Dialog;
	var start:Dialog;

	public function new(r:Rand, interactor:Entity, target:Entity)
	{
		this.r = r;
		this.interactor = interactor;
		this.target = target;

		var trees = target.get(domain.components.Dialog).trees;
		var tree = r.pick(trees);
		start = pickNextDialog(tree.dialogs);
		current = start;
	}

	public function getCurrent()
	{
		return current;
	}

	public function isEnded()
	{
		return current == null;
	}

	public function resetDialog()
	{
		current = start;
	}

	public function getOptions():Array<DialogOption>
	{
		return current.options.filter((o) -> o.conditions.every((c) -> c.check(this)));
	}

	public function pickOption(o:DialogOption)
	{
		current = pickNextDialog(o.dialogs);
	}

	function pickNextDialog(dialogs:Array<Dialog>)
	{
		var valid = dialogs.filter((d) -> d.conditions.every((c) -> c.check(this)));

		return r.pick(valid);
	}
}
