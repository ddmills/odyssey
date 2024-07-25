package domain.stats;

import domain.stats.Stat;

class DodgeStats extends Stat
{
	public function new()
	{
		super(STAT_DODGE, [FINESSE]);
	}
}
