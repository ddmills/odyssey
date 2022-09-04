package domain.events;

import data.SkillType;
import domain.skills.SkillModifier;
import ecs.EntityEvent;

class QuerySkillModEvent extends EntityEvent
{
	public var type:SkillType;
	public var mods:Array<SkillModifier> = new Array();

	public function new(type:SkillType)
	{
		this.type = type;
	}

	public function addMod(mod:SkillModifier)
	{
		mods.push(mod);
	}
}
