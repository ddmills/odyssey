package domain.stats;

import domain.stats.Stat;

class ThrowingStat extends Stat
{
	public function new()
	{
		super(STAT_THROWING, [GRIT]);
	}
}
