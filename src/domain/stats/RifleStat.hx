package domain.stats;

import domain.stats.Stat;

class RifleStat extends Stat
{
	public function new()
	{
		super(STAT_RIFLE, [FINESSE]);
	}
}
