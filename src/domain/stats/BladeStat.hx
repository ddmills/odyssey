package domain.stats;

import domain.stats.Stat;

class BladeStat extends Stat
{
	public function new()
	{
		super(STAT_BLADE, [FINESSE]);
	}
}
