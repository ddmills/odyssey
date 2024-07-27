package screens.character;

import data.AttributeType;
import domain.components.Attributes;
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
		title = 'Attributes';
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
		var attributes = target.get(Attributes);
		var unspent = attributes.getUnspentAttributePoints();
		title = 'Attributes (${unspent} unspent)';
		var items = Attributes.GetAll(target).map(makeListItem);

		setItems(items);
	}

	function incrementAttribute(attribute:AttributeType)
	{
		var attributes = target.get(Attributes);
		attributes.incrementAttribute(attribute);
		refreshList();
	}

	function makeListItem(v:{attribute:AttributeType, value:Int}):ListItem
	{
		return {
			title: EnumValueTools.getName(v.attribute),
			detail: v.value.toString(),
			getIcon: null,
			onSelect: () -> incrementAttribute(v.attribute),
		};
	}
}
