package domain.stats;

import domain.stats.Stat;

class SpeedStat extends Stat
{
	public function new()
	{
		super(STAT_SPEED, [FINESSE]);
	}
}
