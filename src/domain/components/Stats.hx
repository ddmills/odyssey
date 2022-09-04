package domain.components;

import data.StatType;
import ecs.Component;
import ecs.Entity;

class Stats extends Component
{
	public var grit:Int;
	public var savvy:Int;
	public var agility:Int;

	public function get(stat:StatType)
	{
		return switch stat
		{
			case GRIT: grit;
			case SAVVY: savvy;
			case AGILITY: agility;
		}
	}

	public function new()
	{
		grit = 0;
		savvy = 0;
		agility = 0;
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
