package domain.components;

import ecs.Component;

class Moniker extends Component
{
	@save public var baseName = 'Hello world';

	public var displayName(get, never):String;

	public function new(baseName:String)
	{
		this.baseName = baseName;
	}

	function get_displayName():String
	{
		var equipped = entity.get(IsEquipped);
		var stacks = entity.get(Stackable);
		var light = entity.get(Lightable);
		var explosive = entity.get(Explosive);
		var fuelConsumer = entity.get(FuelConsumer);
		var liquid = entity.get(LiquidContainer);
		var door = entity.get(Door);

		var name = baseName;

		if (stacks != null && stacks.displayName.length > 0)
		{
			name += ' ${stacks.displayName}';
		}

		if (equipped != null && equipped.slotDisplay.length > 0)
		{
			name += ' [${equipped.slotDisplay}]';
		}

		if (door != null)
		{
			name += ' [${door.displayName}]';
		}

		if (fuelConsumer != null)
		{
			name += ' [${fuelConsumer.displayName}]';
		}

		if (liquid != null)
		{
			name += ' [${liquid.displayName}]';
		}

		if (light != null)
		{
			name += ' [${light.displayName}]';
		}

		if (explosive != null && explosive.isFuseLit)
		{
			var t = ((explosive.remainingFuseTicks / Clock.TICKS_PER_MINUTE)).format(1);
			name += ' [Lit ${t}m]';
		}

		return name;
	}
}
