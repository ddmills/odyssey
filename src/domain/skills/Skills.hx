package domain.skills;

import common.struct.DataRegistry;
import data.SkillType;

class Skills
{
	private static var skills:DataRegistry<SkillType, Skill> = new DataRegistry();

	public static function Init()
	{
		skills.register(SKILL_RIFLES, new SkillRifle());
		skills.register(SKILL_SHOTGUNS, new SkillShotgun());
		skills.register(SKILL_PISTOLS, new SkillPistol());
		skills.register(SKILL_BRAWLER, new SkillBrawler());
	}

	public static function Get(type:SkillType):Skill
	{
		return skills.get(type);
	}

	public static function GetAll():Array<Skill>
	{
		return skills.getAll();
	}
}
