package screens.dialog;

import data.dialog.Dialog;
import data.dialog.DialogExtraOptions;
import data.dialog.DialogOption;
import ecs.Entity;
import hxd.Rand;

class Conversation
{
	var r:Rand;
	var targetExtraOptions:Array<DialogExtraOptions>;

	public var interactor:Entity;
	public var target:Entity;

	var current:Dialog;
	var start:Dialog;

	public function new(r:Rand, interactor:Entity, target:Entity)
	{
		this.r = r;
		this.interactor = interactor;
		this.target = target;

		resetDialog();
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
		var targetDialog = target.get(domain.components.Dialog);
		targetExtraOptions = targetDialog.options;

		var trees = targetDialog.trees;
		var tree = r.pick(trees);
		start = pickNextDialog(tree.dialogs);
		current = start;
	}

	public function getOptions():Array<DialogOption>
	{
		var extras:Array<DialogOption> = [];

		if (current.allowExtraOptions)
		{
			extras = targetExtraOptions.flatMap((o) -> o.options);
		}

		var options = current.options.concat(extras);

		if (options.length == 0)
		{
			options.push({
				option: 'Ok',
				dialogs: [],
				conditions: [],
				effects: [],
				isEnd: false,
			});
		}

		return options.filter((o) -> o.conditions.every((c) -> c.check(this)));
	}

	public function pickOption(o:DialogOption)
	{
		for (effect in o.effects)
		{
			effect.apply(this);
		}

		if (o.isEnd)
		{
			current = null;
			return;
		}

		current = pickNextDialog(o.dialogs);

		if (isEnded())
		{
			resetDialog();
		}
		else
		{
			for (effect in current.effects)
			{
				effect.apply(this);
			}
		}
	}

	function pickNextDialog(dialogs:Array<Dialog>)
	{
		var valid = dialogs.filter((d) -> d.conditions.every((c) -> c.check(this)));

		return r.pick(valid);
	}
}
