package screens.dialog;

import core.Frame;
import ecs.Entity;
import hxd.Rand;
import screens.dialog.Conversation;
import screens.listSelect.ListSelectScreen;

class DialogScreen extends ListSelectScreen
{
	private var interactor:Entity;
	private var target:Entity;
	private var conversation:Conversation;

	public function new(interactor:Entity, target:Entity)
	{
		this.interactor = interactor;
		this.target = target;
		var r = Rand.create();
		this.conversation = new Conversation(r, interactor, target);
		super([]);
		cancelText = 'Close';
		refreshList();
	}

	private function refreshList()
	{
		if (conversation.isEnded())
		{
			conversation.resetDialog();
		}

		var d = conversation.getCurrent();
		var t = d.say.or(d.helper).or('None');
		title = t;

		var options = conversation.getOptions();

		includeCancel = options.length <= 0;

		var items = conversation.getOptions().map((o) -> ({
			title: '"${o.option}"',
			detail: o.detail,
			getIcon: null,
			onSelect: () ->
			{
				conversation.pickOption(o);
				if (o.isEnd)
				{
					game.screens.pop();
				}
				else
				{
					refreshList();
				}
			},
		}));

		setItems(items);
	}

	override function update(frame:Frame)
	{
		super.update(frame);
		world.updateSystems();
	}
}
