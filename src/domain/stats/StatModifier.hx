package domain.stats;

import data.StatType;

@:structInit class StatModifier
{
	public var source:String;
	public var stat:StatType;
	public var mod:Int;
}
