package domain.events;

import data.StatType;
import domain.stats.StatModifier;
import ecs.EntityEvent;

class QueryStatModEquippedEvent extends EntityEvent
{
	public var stat:StatType;
	public var mods:Array<StatModifier> = new Array();

	public function new(stat:StatType)
	{
		this.stat = stat;
	}

	public function addMod(mod:StatModifier)
	{
		mods.push(mod);
	}
}
