package domain.components;

import core.Game;
import data.ColorKey;
import ecs.Component;

class HitBlink extends Component
{
	@save public var durationSeconds:Float = .4;
	@save public var timeSeconds:Float = 0;
	@save public var rateSeconds:Float = .2;
	@save public var color:ColorKey = C_WHITE;
	@save public var originalColor:ColorKey = Game.instance.CLEAR_COLOR;

	public function new() {}
}
