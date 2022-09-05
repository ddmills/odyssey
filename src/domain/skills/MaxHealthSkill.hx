package domain.skills;

class MaxHealthSkill extends Skill
{
	public function new()
	{
		super(SKILL_MAX_HEALTH, [GRIT]);
	}
}
