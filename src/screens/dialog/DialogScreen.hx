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

		var items = conversation.getOptions().map((o) -> ({
			title: '"${o.option}"',
			detail: o.detail,
			getIcon: null,
			onSelect: () ->
			{
				conversation.pickOption(o);
				refreshList();
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
