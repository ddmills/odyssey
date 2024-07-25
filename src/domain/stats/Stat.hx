package domain.stats;

import data.AttributeType;
import data.StatType;
import domain.components.Attributes;
import domain.events.QueryStatModEvent;
import ecs.Entity;

class Stat
{
	public var type:StatType;
	public var attributes:Array<AttributeType>;

	public function new(type:StatType, attributes:Array<AttributeType>)
	{
		this.type = type;
		this.attributes = attributes;
	}

	public function getModifiers(entity:Entity):Array<StatModifier>
	{
		var evt = new QueryStatModEvent(type);

		entity.fireEvent(evt);

		return evt.mods;
	}

	public function getModifierSum(entity:Entity):Int
	{
		return getModifiers(entity).sum((s) -> s.mod).floor();
	}

	public function compute(entity:Entity):Int
	{
		var attribute = getAttribute(entity);
		var base = attribute != null ? Attributes.Get(entity, attribute) : 0;
		var modifier = getModifierSum(entity);

		return base + modifier;
	}

	public function getAttribute(entity:Entity):Null<AttributeType>
	{
		return attributes.max((s) -> Attributes.Get(entity, s));
	}
}
