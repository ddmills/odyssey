package domain.skills;

import domain.stats.StatModifier;

class SkillPistol extends Skill
{
	public function new()
	{
		super(SKILL_PISTOLS, "Pistol Expert");
	}

	override function getStatModifiers():Array<StatModifier>
	{
		return [
			{
				source: "Pistol Expert",
				stat: STAT_PISTOL,
				mod: 4,
			}
		];
	}
}
