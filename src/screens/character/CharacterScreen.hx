package screens.character;

import data.StatType;
import domain.components.Stats;
import ecs.Entity;
import haxe.EnumTools.EnumValueTools;
import screens.listSelect.ListSelectScreen;

class CharacterScreen extends ListSelectScreen
{
	public var target:Entity;

	public function new(target:Entity)
	{
		this.target = target;
		super([]);
		title = 'Stats';
		cancelText = 'Close';
	}

	override function onResume()
	{
		super.onResume();
		refreshList();
	}

	override function onEnter()
	{
		super.onEnter();
		refreshList();
	}

	function refreshList()
	{
		var stats = target.get(Stats);
		title = 'Stats (${stats.unspentStatPoints} unspent)';
		var items = Stats.GetAll(target).map(makeListItem);

		setItems(items);
	}

	function incrementStat(stat:StatType)
	{
		var stats = target.get(Stats);
		stats.incrementStat(stat);
		refreshList();
	}

	function makeListItem(v:{stat:StatType, value:Int}):ListItem
	{
		return {
			title: EnumValueTools.getName(v.stat),
			detail: v.value.toString(),
			getIcon: null,
			onSelect: () -> incrementStat(v.stat),
		};
	}
}
