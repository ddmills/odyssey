package domain.components;

import common.struct.Coordinate;
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
	@save public var tween:Tween;
	@save public var speed:Float;
	@save public var epsilon:Float;

	public function new(goal:Coordinate, speed:Float = 0.05, tween:Tween = LINEAR, epsilon:Float = .0075)
	{
		this.goal = goal;
		this.tween = tween;
		this.speed = speed;
		this.epsilon = epsilon;
	}
}
