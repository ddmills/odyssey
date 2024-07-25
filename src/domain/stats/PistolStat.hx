package domain.stats;

import domain.stats.Stat;

class PistolStat extends Stat
{
	public function new()
	{
		super(STAT_PISTOL, [GRIT, FINESSE]);
	}
}
