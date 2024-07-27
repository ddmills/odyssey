package domain.events;

import data.AbilityType;
import ecs.EntityEvent;

class QueryAbilitiesEvent extends EntityEvent
{
	public var abilities:Array<AbilityType> = new Array();

	public function new() {}

	public inline function addAbility(ability:AbilityType)
	{
		if (!abilities.contains(ability))
		{
			abilities.push(ability);
		}
	}

	public inline function addAbilities(abilities:Array<AbilityType>)
	{
		for (ability in abilities)
		{
			addAbility(ability);
		}
	}
}
