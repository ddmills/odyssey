package domain.skills;

import data.SkillType;
import domain.skills.SpeedSkill;
import ecs.Entity;

typedef SkillValue =
{
	skill:SkillType,
	value:Int,
}

class Skills
{
	private static var skills:Map<SkillType, Skill> = new Map();

	public static function Init()
	{
		skills.set(SKILL_FORTITUDE, new FortitudeSkill());
		skills.set(SKILL_SPEED, new SpeedSkill());
		skills.set(SKILL_UNARMED, new UnarmedSkill());
		skills.set(SKILL_CUDGEL, new CudgelSkill());
		skills.set(SKILL_RIFLE, new RifleSkill());
		skills.set(SKILL_PISTOL, new PistolSkill());
		skills.set(SKILL_BLADE, new BladeSkill());
		skills.set(SKILL_SHOTGUN, new ShotgunSkill());
		skills.set(SKILL_DODGE, new DodgeSkill());
	}

	public static function Get(type:SkillType):Skill
	{
		return skills.get(type);
	}

	public static function GetValue(type:SkillType, entity:Entity):Int
	{
		return skills.get(type).compute(entity);
	}

	public static function GetAll(entity):Array<SkillValue>
	{
		return skills.map((skill) -> ({
			skill: skill.type,
			value: skill.compute(entity),
		}));
	}
}
