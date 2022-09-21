package domain.components;

import domain.events.QueryVisionModEvent;
import ecs.Component;

class LightSource extends Component
{
	// must be between 0 and 1
	@save public var intensity:Float;
	@save public var range:Int;
	@save public var colour:Int;
	@save public var isEnabled:Bool;
	@save public var visionRangeMin:Int;

	public function new(intensity:Float = .5, colour:Int = 0xffffff, range:Int = 5, isEnabled:Bool = true, visionRangeMin:Int = 0)
	{
		this.intensity = intensity;
		this.range = range;
		this.colour = colour;
		this.isEnabled = isEnabled;
		this.visionRangeMin = visionRangeMin;

		addHandler(QueryVisionModEvent, onQueryVisionMod);
	}

	private function onQueryVisionMod(evt:QueryVisionModEvent)
	{
		if (visionRangeMin > 0 && isEnabled)
		{
			evt.mods.push({
				source: 'LightSource',
				minVision: visionRangeMin,
			});
		}
	}
}
