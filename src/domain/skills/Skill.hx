package domain.skills;

import data.SkillType;
import data.StatType;
import domain.components.Stats;
import domain.events.QuerySkillModEvent;
import ecs.Entity;

class Skill
{
	public var type:SkillType;
	public var stats:Array<StatType>;

	public function new(type:SkillType, stats:Array<StatType>)
	{
		this.type = type;
		this.stats = stats;
	}

	public function getModifiers(entity:Entity):Array<SkillModifier>
	{
		var evt = new QuerySkillModEvent(type);

		entity.fireEvent(evt);

		return evt.mods;
	}

	public function getModifierSum(entity:Entity):Int
	{
		return getModifiers(entity).sum((s) -> s.mod).floor();
	}

	public function compute(entity:Entity):Int
	{
		var stat = getStat(entity);
		var base = stat != null ? Stats.Get(entity, stat) : 0;
		var modifier = getModifierSum(entity);

		return base + modifier;
	}

	function getStat(entity:Entity):Null<StatType>
	{
		return stats.max((s) -> Stats.Get(entity, s));
	}
}
