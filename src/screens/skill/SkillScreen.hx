package screens.skill;

import domain.components.Attributes;
import domain.skills.Skill;
import domain.skills.Skills;
import ecs.Entity;
import screens.listSelect.ListSelectScreen;

class SkillScreen extends ListSelectScreen
{
	public var target:Entity;

	public function new(target:Entity)
	{
		this.target = target;
		super([]);

		title = 'Skills';
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
		title = 'Skills (${attributes.getUnspentSkillPoints()} unspent SP)';

		var items = Skills.GetAll().map((skill) -> makeListItem(skill, attributes));

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

	function makeListItem(skill:Skill, attributes:Attributes):ListItem
	{
		var hasSkill = attributes.skills.contains(skill.type);
		var title = '[${hasSkill ? 'x' : ' '}] ${skill.name}';

		return {
			title: title,
			detail: skill.getCost().toString(),
			getIcon: null,
			onSelect: () -> unlockSkill(skill),
		};
	}
}
