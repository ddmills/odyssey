package domain.ai.behaviours;

import common.struct.DataRegistry;

class Behaviours
{
	public static var behaviours:DataRegistry<BehaviourType, Behaviour>;

	public static function Init()
	{
		behaviours = new DataRegistry();

		behaviours.register(BHV_DYNAMITE, new BehaviourDynamite());
		behaviours.register(BHV_BASIC, new BehaviourBasic());
		behaviours.register(BHV_BASIC_COMPANION, new BehaviourBasicCompanion());
	}

	public static function Get(type:BehaviourType):Behaviour
	{
		return behaviours.get(type);
	}
}
