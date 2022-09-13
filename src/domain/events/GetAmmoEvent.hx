package domain.events;

import data.AmmoType;
import ecs.EntityEvent;

class GetAmmoEvent extends EntityEvent
{
	public var ammoType:AmmoType;
	public var amountRequested:Int;
	public var amount:Int = 0;
	public var isHandled:Bool = false;

	public function new(ammoType:AmmoType, amountRequested:Int)
	{
		this.ammoType = ammoType;
		this.amountRequested = amountRequested;
	}
}
