package domain.components;

import data.FactionType;
import data.Factions;
import domain.data.factions.Faction;
import ecs.Component;

class FactionMember extends Component
{
	@save public var factionType:FactionType;

	public var faction(get, never):Faction;

	public function new(factionType:FactionType)
	{
		this.factionType = factionType;
	}

	inline function get_faction():Faction
	{
		return Factions.Get(factionType);
	}
}
