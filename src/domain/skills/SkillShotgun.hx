package domain.skills;

import domain.stats.StatModifier;

class SkillShotgun extends Skill
{
	public function new()
	{
		super(SKILL_SHOTGUNS, "Shotgun Expert");
	}

	override function getStatModifiers():Array<StatModifier>
	{
		return [
			{
				source: "Shotgun Expert",
				stat: STAT_SHOTGUN,
				mod: 4,
			}
		];
	}
}
