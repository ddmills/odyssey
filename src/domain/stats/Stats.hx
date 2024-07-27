package domain.stats;

import common.struct.DataRegistry;
import data.StatType;
import domain.stats.AnimalHandlingStat;
import domain.stats.SpeedStat;
import domain.stats.Stat;
import domain.stats.UnarmedStat;
import ecs.Entity;

typedef StatValue =
{
	stat:StatType,
	value:Int,
}

class Stats
{
	private static var stats:DataRegistry<StatType, Stat> = new DataRegistry();

	public static function Init()
	{
		stats.register(STAT_FORTITUDE, new FortitudeStat());
		stats.register(STAT_ARMOR, new ArmorStat());
		stats.register(STAT_ARMOR_REGEN, new ArmorStat());
		stats.register(STAT_SPEED, new SpeedStat());
		stats.register(STAT_UNARMED, new UnarmedStat());
		stats.register(STAT_CUDGEL, new CudgelStat());
		stats.register(STAT_RIFLE, new RifleStat());
		stats.register(STAT_PISTOL, new PistolStat());
		stats.register(STAT_BLADE, new BladeStat());
		stats.register(STAT_SHOTGUN, new ShotgunStat());
		stats.register(STAT_DODGE, new DodgeStats());
		stats.register(STAT_ANIMAL_HANDLING, new AnimalHandlingStat());
		stats.register(STAT_FORAGE, new ForageStat());
		stats.register(STAT_LEARNING, new LearningStat());
	}

	public static function Get(type:StatType):Stat
	{
		return stats.get(type);
	}

	public static function GetValue(type:StatType, entity:Entity):Int
	{
		return stats.get(type).compute(entity);
	}

	public static function GetAll(entity):Array<StatValue>
	{
		return stats.map((stat) -> ({
			stat: stat.type,
			value: stat.compute(entity),
		}));
	}
}
