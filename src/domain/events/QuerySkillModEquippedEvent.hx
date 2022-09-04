package domain.events;

import data.SkillType;
import domain.skills.SkillModifier;
import ecs.EntityEvent;

class QuerySkillModEquippedEvent extends EntityEvent
{
	public var skill:SkillType;
	public var mods:Array<SkillModifier> = new Array();

	public function new(skill:SkillType)
	{
		this.skill = skill;
	}

	public function addMod(mod:SkillModifier)
	{
		mods.push(mod);
	}
}
