package domain.skills;

class UnarmedSkill extends Skill
{
	public function new()
	{
		super(SKILL_UNARMED, [GRIT, FINESSE]);
	}
}
