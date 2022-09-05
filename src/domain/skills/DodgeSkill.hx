package domain.skills;

class DodgeSkill extends Skill
{
	public function new()
	{
		super(SKILL_DODGE, [FINESSE]);
	}
}
