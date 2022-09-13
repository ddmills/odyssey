package domain.components;

import data.AmmoType;
import ecs.Component;

class Ammo extends Component
{
	@save public var ammoType:AmmoType;

	public function new(ammoType:AmmoType)
	{
		this.ammoType = ammoType;
	}
}
