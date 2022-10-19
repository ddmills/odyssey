package domain.skills;

import common.struct.DataRegistry;
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
	private static var skills:DataRegistry<SkillType, Skill> = new DataRegistry();

	public static function Init()
	{
		skills.register(SKILL_FORTITUDE, new FortitudeSkill());
		skills.register(SKILL_SPEED, new SpeedSkill());
		skills.register(SKILL_UNARMED, new UnarmedSkill());
		skills.register(SKILL_CUDGEL, new CudgelSkill());
		skills.register(SKILL_RIFLE, new RifleSkill());
		skills.register(SKILL_PISTOL, new PistolSkill());
		skills.register(SKILL_BLADE, new BladeSkill());
		skills.register(SKILL_SHOTGUN, new ShotgunSkill());
		skills.register(SKILL_DODGE, new DodgeSkill());
		skills.register(SKILL_ANIMAL_HANDLING, new AnimalHandlingSkill());
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
