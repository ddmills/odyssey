package domain.stats;

import domain.stats.Stat;

class FortitudeStat extends Stat
{
	public function new()
	{
		super(STAT_FORTITUDE, [GRIT]);
	}
}
