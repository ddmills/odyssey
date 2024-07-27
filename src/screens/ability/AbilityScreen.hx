package screens.ability;

import data.AbilityType;
import domain.abilities.Abilities;
import domain.components.Attributes;
import domain.events.QueryAbilitiesEvent;
import domain.skills.Skill;
import ecs.Entity;
import screens.listSelect.ListSelectScreen;

class AbilityScreen extends ListSelectScreen
{
	public var target:Entity;

	public function new(target:Entity)
	{
		this.target = target;
		super([]);

		title = 'Abilities';
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
		var evt = target.fireEvent(new QueryAbilitiesEvent());
		var items = evt.abilities.map(makeListItem);

		setItems(items);
	}

	function unlockSkill(skill:Skill)
	{
		var attributes = target.get(Attributes);
		if (attributes.getUnspentSkillPoints() >= skill.getCost())
		{
			attributes.unlockSkill(skill.type, false);
		}
		refreshList();
	}

	function makeListItem(abilityType:AbilityType):ListItem
	{
		var ability = Abilities.Get(abilityType);
		var reqMet = ability.isRequirementsMet(target);

		var title = '${reqMet ? '(yes)' : '(no)'} ${ability.name}';

		return {
			title: title,
			detail: ability.getDescription(target),
			getIcon: null,
			onSelect: () ->
			{
				if (reqMet)
				{
					game.screens.pop();
					ability.initiate(target);
				}
			},
		};
	}
}
