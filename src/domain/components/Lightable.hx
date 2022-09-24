package domain.components;

import domain.events.ConsumeEnergyEvent;
import domain.events.ExtinguishEvent;
import domain.events.LightEvent;
import domain.events.PickupEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.UnequippedEvent;
import domain.systems.EnergySystem;
import ecs.Component;

class Lightable extends Component
{
	@save private var allowEquipped:Bool;
	@save private var litColor:Int;

	public var light(get, never):LightSource;
	public var isLit(get, never):Bool;
	public var displayName(get, never):String;

	public function new(allowEquipped:Bool = false, litColor:Int = -1)
	{
		this.allowEquipped = allowEquipped;
		this.litColor = litColor;
		addHandler(QueryInteractionsEvent, (evt) -> onQueryInteractions(cast evt));
		addHandler(LightEvent, (evt) -> onLightEvent(cast evt));
		addHandler(ExtinguishEvent, (evt) -> onExtinguishEvent(cast evt));
		addHandler(PickupEvent, (evt) -> onPickup(cast evt));
		addHandler(UnequippedEvent, (evt) -> onUnequipped(cast evt));
	}

	private function onUnequipped(evt:UnequippedEvent)
	{
		if (entity.has(IsInventoried))
		{
			light.isEnabled = false;
		}
	}

	private function onPickup(evt:PickupEvent)
	{
		light.isEnabled = false;
	}

	private function onLightEvent(evt:LightEvent)
	{
		light.isEnabled = true;

		if (litColor >= 0 && entity.drawable != null)
		{
			entity.drawable.secondaryOverride = litColor;
		}

		var cost = EnergySystem.GetEnergyCost(evt.lighter, ACT_LIGHT);
		evt.lighter.fireEvent(new ConsumeEnergyEvent(cost));
	}

	private function onExtinguishEvent(evt:ExtinguishEvent)
	{
		light.isEnabled = false;

		if (litColor >= 0 && entity.drawable != null)
		{
			entity.drawable.secondaryOverride = null;
		}

		var cost = EnergySystem.GetEnergyCost(evt.extinguisher, ACT_EXTINGUISH);
		evt.extinguisher.fireEvent(new ConsumeEnergyEvent(cost));
	}

	private function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		var isInventoried = entity.has(IsInventoried);
		var isEquipped = entity.has(IsEquipped);

		if (isLit)
		{
			evt.interactions.push({
				name: 'Extinguish',
				evt: new ExtinguishEvent(evt.interactor),
			});
		}
		else if ((allowEquipped && isEquipped) || !isInventoried)
		{
			evt.interactions.push({
				name: 'Light',
				evt: new LightEvent(evt.interactor),
			});
		}
	}

	function get_displayName():String
	{
		if (isLit)
		{
			return 'Lit';
		}
		return
		{
			return 'Unlit';
		}
	}

	inline function get_light():LightSource
	{
		return entity.get(LightSource);
	}

	inline function get_isLit():Bool
	{
		return light.isEnabled;
	}
}
