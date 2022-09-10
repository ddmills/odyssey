package domain.components;

import data.StatType;
import ecs.Component;
import ecs.Entity;

class Stats extends Component
{
	@save public var grit:Int;
	@save public var savvy:Int;
	@save public var finesse:Int;

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

	public static function GetAll(e:Entity):Array<{stat:StatType, value:Int}>
	{
		var stats = e.get(Stats);

		if (stats == null)
		{
			return [];
		}

		return [
			{stat: GRIT, value: stats.grit},
			{stat: SAVVY, value: stats.savvy},
			{stat: FINESSE, value: stats.finesse},
		];
	}
}
