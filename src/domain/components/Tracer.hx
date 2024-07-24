package domain.components;

import common.struct.Coordinate;
import data.ColorKey;
import ecs.Component;

class Tracer extends Component
{
	@save public var start:Coordinate;
	@save public var end:Coordinate;
	@save public var color:ColorKey;
	@save public var age:Float;

	public function new(start:Coordinate, end:Coordinate, color:ColorKey)
	{
		this.start = start;
		this.end = end;
		this.color = color;
		this.age = 0;
	}
}
