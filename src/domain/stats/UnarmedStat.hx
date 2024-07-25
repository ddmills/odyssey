package domain.stats;

import domain.stats.Stat;

class UnarmedStat extends Stat
{
	public function new()
	{
		super(STAT_UNARMED, [GRIT, FINESSE]);
	}
}
