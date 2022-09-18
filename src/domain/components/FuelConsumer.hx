package domain.components;

import data.FuelType;
import domain.events.EntityLoadedEvent;
import domain.events.FuelDepletedEvent;
import ecs.Component;

class FuelConsumer extends Component
{
	@save public var fuelTypes:Array<FuelType>;
	@save public var amount:Float;
	@save public var maximum:Int;
	@save public var ratePerTurn:Float;
	@save public var isEnabled:Bool;
	@save public var isRefillable:Bool;

	public var hasFuel(get, never):Bool;

	public function new(fuelTypes:Array<FuelType>, amount:Float = 0, maximum:Int = 100, ratePerTurn:Float = 1, isEnabled:Bool = false,
			isRefillable:Bool = true)
	{
		this.fuelTypes = fuelTypes;
		this.amount = amount;
		this.maximum = maximum;
		this.ratePerTurn = ratePerTurn;
		this.isEnabled = isEnabled;
		this.isRefillable = isRefillable;

		addHandler(EntityLoadedEvent, (evt) -> onEntityLoaded(cast evt));
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
			trace('NO FUEL LEFT');
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
}
