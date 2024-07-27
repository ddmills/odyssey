package domain.skills;

import domain.stats.StatModifier;

class SkillRifle extends Skill
{
	public function new()
	{
		super(SKILL_RIFLES, "Rifle Expert");
	}

	override function getStatModifiers():Array<StatModifier>
	{
		return [
			{
				source: "Rifle Expert",
				stat: STAT_RIFLE,
				mod: 4,
			}
		];
	}
}
