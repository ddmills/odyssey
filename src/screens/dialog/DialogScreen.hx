package screens.dialog;

import core.Frame;
import data.AnimationResources;
import data.ColorKey;
import domain.components.Moniker;
import ecs.Entity;
import h2d.Anim;
import hxd.Rand;
import screens.dialog.Conversation;
import screens.listSelect.ListSelectScreen;
import shaders.SpriteShader;

class DialogScreen extends ListSelectScreen
{
	private var interactor:Entity;
	private var target:Entity;
	private var conversation:Conversation;
	private var targetBm:Anim;
	private var targetShader:SpriteShader;

	public function new(interactor:Entity, target:Entity)
	{
		this.interactor = interactor;
		this.target = target;
		var r = Rand.create();
		this.conversation = new Conversation(r, interactor, target);
		super([]);

		targetShader = new SpriteShader(ColorKey.C_YELLOW);
		targetShader.ignoreLighting = 1;
		targetBm = new Anim(AnimationResources.Get(CURSOR_SPIN), 10, ob);
		targetBm.addShader(targetShader);

		cancelText = 'Close';
		refreshList();
	}

	override function onEnter()
	{
		super.onEnter();
		game.render(OVERLAY, targetBm);
	}

	override function onDestroy()
	{
		targetBm.remove();
		super.onDestroy();
	}

	private function refreshList()
	{
		if (conversation.isEnded())
		{
			conversation.resetDialog();
		}

		var relation = world.factions.getEntityRelation(interactor, target);
		var disp = world.factions.getDisplay(relation, true);
		var moniker = target.get(Moniker).displayName;

		var d = conversation.getCurrent();
		var t = d.say.or(d.helper).or('None');
		title = '$moniker [$disp] "$t"';

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
		var tpos = target.pos.toPx();
		targetBm.visible = true;
		targetBm.x = tpos.x;
		targetBm.y = tpos.y;
		super.update(frame);
		world.updateSystems();
	}
}
