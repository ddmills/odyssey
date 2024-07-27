package domain.abilities;

import common.struct.DataRegistry;
import data.AbilityType;

class Abilities
{
	private static var abilities:DataRegistry<AbilityType, Ability> = new DataRegistry();

	public static function Init()
	{
		abilities.register(ABILITY_BARRAGE, new AbilityBarrage());
	}

	public static function Get(ability:AbilityType):Ability
	{
		return abilities.get(ability);
	}
}
