package domain.components;

import data.SkillType;
import domain.events.QuerySkillModEquippedEvent;
import ecs.Component;

class EquippedSkillMod extends Component
{
	static var allowMultiple = true;

	@save public var mods:Map<SkillType, Int> = new Map();

	public function new()
	{
		addHandler(QuerySkillModEquippedEvent, (evt) -> onQuerySkillModEquipped(cast evt));
	}

	public function set(skill:SkillType, value:Int)
	{
		if (value == 0)
		{
			mods.remove(skill);
		}
		else
		{
			mods.set(skill, value);
		}
	}

	public function get(skill:SkillType):Int
	{
		var mod = mods.get(skill);
		return mod == null ? 0 : mod;
	}

	private function onQuerySkillModEquipped(evt:QuerySkillModEquippedEvent)
	{
		var mod = get(evt.skill);
		if (mod != 0)
		{
			evt.mods.push({
				mod: mod,
				skill: evt.skill,
				source: entity.get(Moniker).displayName,
			});
		}
	}
}
