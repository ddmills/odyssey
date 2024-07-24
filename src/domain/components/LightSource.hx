package domain.components;

import domain.events.EntityLoadedEvent;
import domain.events.EntitySpawnedEvent;
import ecs.Component;

class LightSource extends Component
{
	// must be between 0 and 1
	@save public var intensity:Float;
	@save public var range:Int;
	@save public var color:Int;
	@save public var isEnabled(default, set):Bool;
	@save public var disableLutShader(default, set):Bool;

	public function new(intensity:Float = .5, colour:Int = 0xffffff, range:Int = 5, isEnabled:Bool = true, disableLutShader:Bool = true)
	{
		this.intensity = intensity;
		this.range = range;
		this.color = colour;
		this.isEnabled = isEnabled;
		this.disableLutShader = disableLutShader;

		addHandler(EntityLoadedEvent, onEntityLoaded);
		addHandler(EntitySpawnedEvent, onEntitySpawned);
	}

	private function onEntityLoaded(evt:EntityLoadedEvent)
	{
		updateShader();
	}

	private function onEntitySpawned(evt:EntitySpawnedEvent)
	{
		updateShader();
	}

	private function updateShader()
	{
		if (entity != null && entity.drawable != null)
		{
			entity.drawable.enableLutShader = !disableLutShader;
		}
	}

	function set_disableLutShader(value:Bool):Bool
	{
		disableLutShader = value;
		updateShader();
		return value;
	}

	function set_isEnabled(value:Bool):Bool
	{
		isEnabled = value;
		updateShader();
		return value;
	}
}
