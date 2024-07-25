package domain.stats;

import domain.stats.Stat;

class AnimalHandlingStat extends Stat
{
	public function new()
	{
		super(STAT_ANIMAL_HANDLING, [SAVVY]);
	}
}
