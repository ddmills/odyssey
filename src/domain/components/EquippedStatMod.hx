package domain.components;

import data.StatType;
import domain.events.QueryStatModEquippedEvent;
import ecs.Component;

class EquippedStatMod extends Component
{
	static var allowMultiple = true;

	@save public var mods:Map<StatType, Int> = new Map();

	public function new()
	{
		addHandler(QueryStatModEquippedEvent, onQueryStatModEquipped);
	}

	public function set(stat:StatType, value:Int)
	{
		if (value == 0)
		{
			mods.remove(stat);
		}
		else
		{
			mods.set(stat, value);
		}
	}

	public function get(stat:StatType):Int
	{
		var mod = mods.get(stat);
		return mod == null ? 0 : mod;
	}

	private function onQueryStatModEquipped(evt:QueryStatModEquippedEvent)
	{
		var mod = get(evt.stat);
		if (mod != 0)
		{
			evt.mods.push({
				mod: mod,
				stat: evt.stat,
				source: entity.get(Moniker).displayName,
			});
		}
	}
}
