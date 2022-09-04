package domain.components;

import data.StatType;
import ecs.Component;
import ecs.Entity;

class Stats extends Component
{
	public var grit:Int;
	public var savvy:Int;
	public var finesse:Int;

	public function get(stat:StatType)
	{
		return switch stat
		{
			case GRIT: grit;
			case SAVVY: savvy;
			case FINESSE: finesse;
		}
	}

	public function new(grit:Int = 0, savvy:Int = 0, finesse:Int = 0)
	{
		this.grit = grit;
		this.savvy = savvy;
		this.finesse = finesse;
	}

	public static function Get(e:Entity, type:StatType):Int
	{
		var stats = e.get(Stats);

		if (stats == null)
		{
			return 0;
		}

		return stats.get(type);
	}
}
