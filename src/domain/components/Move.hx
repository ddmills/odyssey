package domain.components;

import common.struct.Coordinate;
import common.util.Easing;
import core.Game;
import ecs.Component;

enum Tween
{
	LINEAR;
	LERP;
	INSTANT;
}

class Move extends Component
{
	@save public var goal:Coordinate;
	@save public var start:Coordinate;
	@save public var ease:EasingType;
	@save public var duration:Float;
	@save public var epsilon:Float;
	@save public var isMovedFired:Bool;

	public var startTime:Float;

	public function new(goal:Coordinate, duration:Float = 0.5, ease:EasingType = EASE_LINEAR, epsilon:Float = .0025)
	{
		this.goal = goal;
		this.ease = ease;
		this.duration = duration;
		this.epsilon = epsilon;
		isMovedFired = false;
	}
}
