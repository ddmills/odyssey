package domain.skills;

import data.AbilityType;

class SkillBarrage extends Skill
{
	public function new()
	{
		super(SKILL_BARRAGE, "Barrage");
	}

	override function getAbilities():Array<AbilityType>
	{
		return [ABILITY_BARRAGE];
	}
}
