package domain.stats;

import domain.stats.Stat;

class ForageStat extends Stat
{
	public function new()
	{
		super(STAT_FORAGE, [SAVVY]);
	}
}
