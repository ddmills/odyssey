package domain.components;

import data.TileKey;
import ecs.Component;

class Cruashable extends Component
{
	@save public var tileReplace:TileKey;
	@save public var removeLightBlocker:Bool;

	public function new(tileReplace:TileKey, removeLightBlocker:Bool = true)
	{
		this.tileReplace = tileReplace;
		this.removeLightBlocker = removeLightBlocker;
	}

	public function onCrushed()
	{
		entity.get(Sprite).tileKey = tileReplace;
		entity.remove(LightBlocker);
	}
}
