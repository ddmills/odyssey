package domain.events;

import data.SkillType;
import ecs.EntityEvent;

class QuerySkillsEvent extends EntityEvent
{
	public var skills:Array<SkillType> = new Array();

	public function new() {}

	public inline function addSkill(skill:SkillType)
	{
		if (!skills.contains(skill))
		{
			skills.push(skill);
		}
	}

	public inline function addSkills(skills:Array<SkillType>)
	{
		for (skill in skills)
		{
			addSkill(skill);
		}
	}
}
