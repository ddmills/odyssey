package domain.components;

import core.Game;
import data.FuelType;
import domain.events.EntityLoadedEvent;
import domain.events.FuelDepletedEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.RefuelEvent;
import ecs.Component;
import ecs.Entity;
import screens.entitySelect.EntitySelectScreen;
import screens.prompt.NumberPromptScreen;

class FuelConsumer extends Component
{
	@save public var fuelTypes:Array<FuelType>;
	@save public var amount:Float;
	@save public var maximum:Int;
	@save public var ratePerTurn:Float;
	@save public var isEnabled:Bool;
	@save public var isRefillable:Bool;

	public var hasFuel(get, never):Bool;
	public var isFull(get, never):Bool;
	public var displayName(get, never):String;
	public var hoursRemaining(get, never):Float;

	public function new(fuelTypes:Array<FuelType>, amount:Float = 0, maximum:Int = 100, ratePerTurn:Float = 1, isEnabled:Bool = false,
			isRefillable:Bool = true)
	{
		this.fuelTypes = fuelTypes;
		this.amount = amount;
		this.maximum = maximum;
		this.ratePerTurn = ratePerTurn;
		this.isEnabled = isEnabled;
		this.isRefillable = isRefillable;

		addHandler(EntityLoadedEvent, onEntityLoaded);
		addHandler(QueryInteractionsEvent, onQueryInteractions);
		addHandler(RefuelEvent, onRefuelEvent);
	}

	private function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (isRefillable && !isFull)
		{
			var candidates = getMatchingInventoryFuel(evt.interactor);

			if (candidates.length > 0)
			{
				evt.interactions.push({
					name: 'Add fuel',
					evt: new RefuelEvent(evt.interactor),
				});
			}
		}
	}

	private function addFuelEntity(fuelEntity:Entity, quantity:Int = 1)
	{
		var fuel = fuelEntity.get(Fuel);
		var stack = fuelEntity.get(Stackable);
		var amountToAdd = fuel.amount;

		if (stack != null)
		{
			amountToAdd = fuel.amountPerStack * quantity;
		}

		var leftover = addFuel(amountToAdd);

		fuel.consume(amountToAdd - leftover);
	}

	private function onRefuelEvent(evt:RefuelEvent)
	{
		var candidates = getMatchingInventoryFuel(evt.refueler);

		if (candidates.length <= 0)
		{
			return;
		}

		var s = new EntitySelectScreen(candidates);

		s.onSelect = ((e) ->
		{
			var stack = e.get(Stackable);
			if (stack != null)
			{
				var s = new NumberPromptScreen();
				s.title = 'How many to add? (${stack.quantity} total)';
				s.setValue(stack.quantity);
				s.onAccept = (_) ->
				{
					if (s.value > 0)
					{
						addFuelEntity(e, s.value);
					}
					Game.instance.screens.pop();
				}
				Game.instance.screens.replace(s);
			}
			else
			{
				addFuelEntity(e);
				Game.instance.screens.pop();
			}
		});

		Game.instance.screens.push(s);
	}

	private function getMatchingInventoryFuel(other:Entity):Array<Entity>
	{
		var inventory = other.get(Inventory);
		if (inventory == null)
		{
			return [];
		}
		return inventory.content.filter((c) ->
		{
			return c.has(Fuel) && fuelTypes.contains(c.get(Fuel).fuelType);
		});
	}

	private function onEntityLoaded(evt:EntityLoadedEvent)
	{
		onTickDelta(evt.tickDelta);
	}

	function get_hasFuel():Bool
	{
		return amount > 0;
	}

	public function onTickDelta(tickDelta:Int)
	{
		if (!isEnabled)
		{
			return;
		}

		amount -= ((ratePerTurn / Clock.TICKS_PER_TURN) * tickDelta);

		if (amount <= 0)
		{
			amount = 0;
			isEnabled = false;
			entity.fireEvent(new FuelDepletedEvent());
		}
	}

	/**
	 * Adds fuel to this consumer, returning any leftover
	 *
	 * @returns the leftover amount
	 */
	public function addFuel(amountToAdd:Int):Int
	{
		var newAmount = (amount + amountToAdd).floor();
		if (newAmount > maximum)
		{
			amount = maximum;
			return newAmount - maximum;
		}

		amount = newAmount;
		return 0;
	}

	function get_isFull():Bool
	{
		return amount >= maximum;
	}

	function get_displayName():String
	{
		var hours = hoursRemaining.format(2);
		return '$hours hours of fuel';
	}

	function get_hoursRemaining():Float
	{
		return Clock.ticksToHours(((amount * Clock.TICKS_PER_TURN) / ratePerTurn).floor());
	}
}
