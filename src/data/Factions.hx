package data;

import common.struct.DataRegistry;
import domain.data.factions.Faction;

class Factions
{
	private static var factions:DataRegistry<FactionType, Faction>;

	public static function Init()
	{
		factions = new DataRegistry();

		addFaction('Player', FACTION_PLAYER);
		addFaction('Bandit', FACTION_BANDIT);
		addFaction('Church', FACTION_CHURCH);
		addFaction('Village', FACTION_VILLAGE);
		addFaction('Wildlife', FACTION_WILDLIFE);
	}

	private static function addFaction(name:String, type:FactionType)
	{
		factions.register(type, {
			name: name,
			type: type,
		});
	}

	public static function Get(type:FactionType):Faction
	{
		return factions.get(type);
	}
}
