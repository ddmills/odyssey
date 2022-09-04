package domain.skills;

import data.SkillType;
import domain.skills.SpeedSkill;
import ecs.Entity;

class Skills
{
	private static var skills:Map<SkillType, Skill> = new Map();

	public static function Init()
	{
		skills.set(SKILL_MAX_HEALTH, new MaxHealthSkill());
		skills.set(SKILL_SPEED, new SpeedSkill());
	}

	public static function get(type:SkillType):Skill
	{
		return skills.get(type);
	}

	public static function getValue(type:SkillType, entity:Entity):Int
	{
		return skills.get(type).compute(entity);
	}
}
