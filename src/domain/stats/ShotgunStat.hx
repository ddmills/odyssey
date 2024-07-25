package domain.stats;

import domain.stats.Stat;

class ShotgunStat extends Stat
{
	public function new()
	{
		super(STAT_SHOTGUN, [GRIT]);
	}
}
