package domain.components;

import data.FactionType;
import data.Factions;
import domain.data.factions.Faction;
import domain.events.AttackedEvent;
import ecs.Component;

typedef FactionModifier =
{
	value:Int,
};

class FactionMember extends Component
{
	@save public var factionType:FactionType;
	@save public var modifiers:Map<FactionType, FactionModifier>;

	public var faction(get, never):Faction;

	public function new(factionType:FactionType)
	{
		this.factionType = factionType;
		this.modifiers = [];

		addHandler(AttackedEvent, onAttacked);
	}

	private function onAttacked(evt:AttackedEvent)
	{
		if (entity.has(IsPlayer))
		{
			return;
		}

		var member = evt.attack.attacker.get(FactionMember);

		if (member != null)
		{
			setModifier(member.factionType, -1000);
		}
	}

	public function setModifier(target:FactionType, value:Int)
	{
		modifiers.set(target, {
			value: value,
		});
	}

	public function getModifier(target:FactionType)
	{
		return modifiers.get(target);
	}

	inline function get_faction():Faction
	{
		return Factions.Get(factionType);
	}
}
