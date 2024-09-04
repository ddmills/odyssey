package domain.components;

import core.Game;
import data.ColorKey;
import ecs.Component;

class HitBlink extends Component
{
	@save public var durationSeconds:Float = .2;
	@save public var timeSeconds:Float = 0;
	@save public var rateSeconds:Float = .1;
	@save public var color:ColorKey = C_BRIGHT_WHITE;
	@save public var originalColor:ColorKey = C_CLEAR;

	public function new() {}
}
