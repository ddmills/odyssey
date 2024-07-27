package domain.stats;

import domain.stats.Stat;

class LearningStat extends Stat
{
	public function new()
	{
		super(STAT_LEARNING, [SAVVY]);
	}
}
