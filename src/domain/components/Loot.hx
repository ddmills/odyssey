package domain.components;

import common.struct.Coordinate;
import core.Game;
import data.AudioKey;
import domain.events.DropEvent;
import domain.events.PickupEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.TakeEvent;
import domain.systems.EnergySystem;
import ecs.Component;
import ecs.Entity;
import screens.prompt.NumberPromptScreen;

class Loot extends Component
{
	public var isInventoried(get, never):Bool;
	public var container(get, never):Inventory;

	public var pickupSound:AudioKey;
	public var dropSound:AudioKey;

	public function new()
	{
		pickupSound = LOOT_PICKUP_1;
		dropSound = LOOT_DROP_1;
		addHandler(QueryInteractionsEvent, onQueryInteractions);
		addHandler(PickupEvent, onPickup);
		addHandler(DropEvent, onDrop);
		addHandler(TakeEvent, onTake);
	}

	public function take(taker:Entity, ?quantity:Int, ?addToInventory:Bool = true)
	{
		var stack = entity.get(Stackable);
		if (stack == null || quantity == null || quantity >= stack.quantity)
		{
			if (container != null)
			{
				container.removeLoot(entity);
			}
			if (addToInventory)
			{
				taker.get(Inventory).addLoot(entity);
			}
			return entity;
		}

		if (container != null)
		{
			var loot = container.removeLoot(entity, quantity, false);
			if (addToInventory)
			{
				taker.get(Inventory).addLoot(loot);
			}
			return loot;
		}
		else
		{
			// this comes when equipping off ground?
			// todo take single?? when? from equipment slot equip? does this work?
			trace('todo');
			var clone = entity.clone();
			clone.get(Stackable).quantity -= quantity;
			stack.quantity = quantity;
			if (addToInventory)
			{
				taker.get(Inventory).addLoot(entity);
			}
			return entity;
		}
	}

	public function drop(pos:Coordinate, ?quantity:Int)
	{
		removeFromInventory(pos, quantity);
		Game.instance.audio.play(dropSound);
	}

	public function removeFromInventory(pos:Coordinate, ?quantity:Int):Entity
	{
		return container.dropLoot(entity, pos, quantity);
	}

	public function pickup(taker:Entity, ?quantity:Int)
	{
		var stack = entity.get(Stackable);
		if (stack == null || quantity == null || quantity >= stack.quantity)
		{
			taker.get(Inventory).addLoot(entity);
			Game.instance.audio.play(pickupSound);
			return;
		}

		var clone = entity.clone();
		clone.get(Stackable).quantity -= quantity;
		stack.quantity = quantity;
		taker.get(Inventory).addLoot(entity);
	}

	private function onPickup(evt:PickupEvent)
	{
		var stack = entity.get(Stackable);
		EnergySystem.ConsumeEnergy(evt.interactor, ACT_PICKUP);

		if (stack == null || stack.quantity == 1)
		{
			pickup(evt.interactor);
			return;
		}

		pickup(evt.interactor, stack.quantity);
	}

	private function onDrop(evt:DropEvent)
	{
		var stack = entity.get(Stackable);

		if (stack == null || stack.quantity == 1)
		{
			EnergySystem.ConsumeEnergy(evt.dropper, ACT_DROP);
			drop(evt.pos);
			return;
		}

		var s = new NumberPromptScreen();
		s.title = 'How many to drop? (${stack.quantity} total)';
		s.setValue(stack.quantity);
		s.onAccept = (_) ->
		{
			if (s.value > 0)
			{
				EnergySystem.ConsumeEnergy(evt.dropper, ACT_DROP);
				drop(evt.pos, s.value);
			}
			Game.instance.screens.pop();
		}
		Game.instance.screens.push(s);
	}

	private function onTake(evt:TakeEvent)
	{
		var stack = entity.get(Stackable);

		if (stack == null || stack.quantity == 1)
		{
			Game.instance.audio.play(pickupSound);
			EnergySystem.ConsumeEnergy(evt.taker, ACT_TAKE);

			take(evt.taker);
			return;
		}

		var s = new NumberPromptScreen();
		s.title = 'How many to take? (${stack.quantity} total)';
		s.setValue(stack.quantity);
		s.onAccept = (_) ->
		{
			if (s.value > 0)
			{
				Game.instance.audio.play(pickupSound);
				EnergySystem.ConsumeEnergy(evt.taker, ACT_TAKE);
				take(evt.taker, s.value);
			}
			Game.instance.screens.pop();
		}
		Game.instance.screens.push(s);
	}

	private function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (isInventoried)
		{
			if (evt.interactor.id == container.entity.id)
			{
				evt.add({
					name: 'Drop',
					evt: new DropEvent(evt.interactor),
				});
			}
			else if (evt.interactor.has(Inventory))
			{
				evt.add({
					name: 'Take',
					evt: new TakeEvent(evt.interactor),
				});
			}
		}
		else
		{
			evt.add({
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
