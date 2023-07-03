package domain.components;

import core.Game;
import domain.events.DamagedEvent;
import ecs.Component;

class IsSleeping extends Component
{
	@save public var durationTicks(default, null):Int;
	@save public var startingTick(default, null):Int;
	public var ticksRemaining(get, never):Float;

	public function new(durationTicks:Int)
	{
		this.durationTicks = durationTicks;
		this.startingTick = Game.instance.world.clock.tick;
		addHandler(DamagedEvent, onDamaged);
	}

	function get_ticksRemaining():Float
	{
		return (durationTicks - (Game.instance.world.clock.tick - startingTick));
	}

	private function onDamaged(evt:DamagedEvent)
	{
		trace('CANCEL SLEEP.');
		entity.remove(this);
	}
}
