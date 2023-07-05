package domain.components;

import core.Game;
import ecs.Component;

class HitBlink extends Component
{
	@save public var durationSeconds:Float = .4;
	@save public var timeSeconds:Float = 0;
	@save public var rateSeconds:Float = .2;
	@save public var color:Int = 0xeeeeee;
	@save public var originalColor:Int = Game.instance.CLEAR_COLOR;

	public function new() {}
}
