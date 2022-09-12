package domain.components;

import common.struct.Coordinate;
import core.Game;
import data.AudioKey;
import domain.events.DropEvent;
import domain.events.PickupEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.TakeEvent;
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
		addHandler(QueryInteractionsEvent, (evt) -> onQueryInteractions(cast evt));
		addHandler(PickupEvent, (evt) -> onPickup(cast evt));
		addHandler(DropEvent, (evt) -> onDrop(cast evt));
		addHandler(TakeEvent, (evt) -> onTake(cast evt));
	}

	public function take(taker:Entity, ?quantity:Int)
	{
		Game.instance.audio.play(pickupSound);
		var stack = entity.get(Stackable);
		if (stack == null || quantity == null || quantity >= stack.quantity)
		{
			if (container != null)
			{
				container.removeLoot(entity);
			}
			taker.get(Inventory).addLoot(entity);
			return;
		}

		if (container != null)
		{
			var loot = container.removeLoot(entity, quantity, false);
			taker.get(Inventory).addLoot(loot);
		}
		else
		{
			// this comes when equipping off ground?
			// todo take single?? when? from equipment slot equip? does this work?
			trace('todo');
			var clone = entity.clone();
			clone.get(Stackable).quantity -= quantity;
			stack.quantity = quantity;
			taker.get(Inventory).addLoot(entity);
		}
	}

	public function drop(pos:Coordinate, ?quantity:Int)
	{
		container.dropLoot(entity, pos, quantity);
		Game.instance.audio.play(dropSound);
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

		if (stack == null || stack.quantity == 1)
		{
			pickup(evt.interactor);
			return;
		}

		var s = new NumberPromptScreen();
		s.title = 'How many to pickup? (${stack.quantity} total)';
		s.value = stack.quantity;
		s.onAccept = (_) ->
		{
			if (s.value > 0)
			{
				pickup(evt.interactor, s.value);
			}
			Game.instance.screens.pop();
		}
		Game.instance.screens.push(s);
	}

	private function onDrop(evt:DropEvent)
	{
		var stack = entity.get(Stackable);

		if (stack == null || stack.quantity == 1)
		{
			drop(evt.pos);
			return;
		}

		var s = new NumberPromptScreen();
		s.title = 'How many to drop? (${stack.quantity} total)';
		s.value = stack.quantity;
		s.onAccept = (_) ->
		{
			if (s.value > 0)
			{
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
			take(evt.taker);
			return;
		}

		var s = new NumberPromptScreen();
		s.title = 'How many to take? (${stack.quantity} total)';
		s.value = stack.quantity;
		s.onAccept = (_) ->
		{
			if (s.value > 0)
			{
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
