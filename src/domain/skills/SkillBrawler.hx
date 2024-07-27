package domain.skills;

import domain.stats.StatModifier;

class SkillBrawler extends Skill
{
	public function new()
	{
		super(SKILL_BRAWLER, "Brawler");
	}

	override function getStatModifiers():Array<StatModifier>
	{
		return [
			{
				source: "Brawler",
				stat: STAT_UNARMED,
				mod: 4,
			}
		];
	}
}
