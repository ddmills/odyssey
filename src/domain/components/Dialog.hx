package domain.components;

import core.Game;
import data.dialog.DialogExtraOptionType;
import data.dialog.DialogExtraOptions;
import data.dialog.DialogTree;
import data.dialog.DialogTreeType;
import data.dialog.DialogTrees;
import domain.events.QueryInteractionsEvent;
import domain.events.TalkEvent;
import ecs.Component;
import screens.dialog.DialogScreen;

class Dialog extends Component
{
	@save public var treeTypes:Array<DialogTreeType>;
	@save public var optionTypes:Array<DialogExtraOptionType>;
	@save public var flags:Array<String>;

	public var options(get, never):Array<DialogExtraOptions>;
	public var trees(get, never):Array<DialogTree>;

	public function new(treeTypes:Array<DialogTreeType>, ?optionTypes:Array<DialogExtraOptionType>)
	{
		this.treeTypes = treeTypes;
		this.optionTypes = optionTypes.or([]);
		this.flags = [];

		addHandler(TalkEvent, onTalk);
		addHandler(QueryInteractionsEvent, onQueryInteractions);
	}

	public function setFlag(flag:String, value:Bool)
	{
		if (value)
		{
			if (!hasFlag(flag))
			{
				flags.push(flag);
			}
		}
		else
		{
			flags.remove(flag);
		}
	}

	public function hasFlag(flag:String):Bool
	{
		return flags.contains(flag);
	}

	private function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (treeTypes.length > 0)
		{
			evt.add({
				name: 'Talk',
				evt: new TalkEvent(evt.interactor),
				popScreen: true,
			});
		}
	}

	private function onTalk(evt:TalkEvent)
	{
		var s = new DialogScreen(evt.talker, entity);
		Game.instance.screens.push(s);
	}

	inline function get_trees():Array<DialogTree>
	{
		return treeTypes.map(DialogTrees.Get);
	}

	inline function get_options():Array<DialogExtraOptions>
	{
		return optionTypes.map(DialogTrees.GetExtraOptions);
	}
}
