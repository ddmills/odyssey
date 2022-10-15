package domain.components;

import data.dialog.DialogTree;
import data.dialog.DialogTreeType;
import data.dialog.DialogTrees;
import domain.events.QueryInteractionsEvent;
import domain.events.TalkEvent;
import ecs.Component;

class Dialog extends Component
{
	@save public var treeTypes:Array<DialogTreeType>;

	public var trees(get, never):Array<DialogTree>;

	public function new(treeTypes:Array<DialogTreeType>)
	{
		this.treeTypes = treeTypes;
		addHandler(TalkEvent, onTalk);
		addHandler(QueryInteractionsEvent, onQueryInteractions);
	}

	private function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (treeTypes.length > 0)
		{
			evt.add({
				name: 'Talk',
				evt: new TalkEvent(evt.interactor),
			});
		}
	}

	private function onTalk(evt:TalkEvent)
	{
		trace('talk');
	}

	inline function get_trees():Array<DialogTree>
	{
		return treeTypes.map((t) -> DialogTrees.Get(t));
	}
}
