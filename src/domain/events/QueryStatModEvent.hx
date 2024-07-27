package domain.events;

import data.StatType;
import domain.stats.StatModifier;
import ecs.EntityEvent;

class QueryStatModEvent extends EntityEvent
{
	public var stat:StatType;
	public var mods:Array<StatModifier> = new Array();

	public function new(stat:StatType)
	{
		this.stat = stat;
	}

	public inline function addMod(mod:StatModifier)
	{
		mods.push(mod);
	}

	public inline function addMods(mods:Array<StatModifier>)
	{
		for (mod in mods)
		{
			addMod(mod);
		}
	}
}
