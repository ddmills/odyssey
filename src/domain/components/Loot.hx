package domain.components;

import core.Game;
import data.SoundResources;
import domain.events.DropEvent;
import domain.events.PickupEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.TakeEvent;
import ecs.Component;
import ecs.Entity;
import hxd.res.Sound;

class Loot extends Component
{
	public var isInventoried(get, never):Bool;
	public var container(get, never):Inventory;

	public var pickupSound:Sound;
	public var dropSound:Sound;

	public function new()
	{
		pickupSound = SoundResources.LOOT_PICKUP_1;
		dropSound = SoundResources.LOOT_DROP_1;
		addHandler(QueryInteractionsEvent, (evt) -> onQueryInteractions(cast evt));
		addHandler(PickupEvent, (evt) -> onPickup(cast evt));
		addHandler(DropEvent, (evt) -> onDrop(cast evt));
		addHandler(TakeEvent, (evt) -> onTake(cast evt));
	}

	public function take(taker:Entity)
	{
		if (container != null)
		{
			container.removeLoot(entity);
		}
		taker.get(Inventory).addLoot(entity);
	}

	private function onPickup(evt:PickupEvent)
	{
		var targetInventory = evt.interactor.get(Inventory);

		targetInventory.addLoot(entity);

		Game.instance.audio.play(pickupSound);
	}

	private function onDrop(evt:DropEvent)
	{
		container.dropLoot(entity, evt.pos);
		Game.instance.audio.play(dropSound);
	}

	private function onTake(evt:TakeEvent)
	{
		Game.instance.audio.play(pickupSound);
		take(evt.taker);
	}

	private function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (isInventoried)
		{
			if (evt.interactor.id == container.entity.id)
			{
				evt.interactions.push({
					name: 'Drop',
					evt: new DropEvent(evt.interactor),
				});
			}
			else if (evt.interactor.has(Inventory))
			{
				evt.interactions.push({
					name: 'Take',
					evt: new TakeEvent(evt.interactor),
				});
			}
		}
		else
		{
			evt.interactions.push({
				name: 'Pickup',
				evt: new PickupEvent(evt.interactor),
			});
		}
	}

	function get_isInventoried():Bool
	{
		return entity.has(IsInventoried);
	}

	function get_container():Null<Inventory>
	{
		var isInv = entity.get(IsInventoried);
		if (isInv == null)
		{
			return null;
		}

		return isInv.holder.get(Inventory);
	}
}
