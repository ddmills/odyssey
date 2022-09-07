package domain.components;

import data.WeaponFamilyType;
import domain.events.MeleeEvent;
import domain.events.ShootEvent;
import domain.weapons.Weapons;
import ecs.Component;

class Weapon extends Component
{
	public var family:WeaponFamilyType;
	public var die:Int = 6;
	public var modifier:Int = 0;
	public var accuracy:Int = 0;
	public var baseCost:Int = 80;

	public function new(family:WeaponFamilyType)
	{
		this.family = family;
		addHandler(MeleeEvent, (evt) -> onMelee(cast evt));
		addHandler(ShootEvent, (evt) -> onShoot(cast evt));
	}

	public function onMelee(evt:MeleeEvent)
	{
		Weapons.Get(family).doMelee(evt.attacker, evt.defender, this);
		evt.isHandled = true;
	}

	public function onShoot(evt:ShootEvent)
	{
		var f = Weapons.Get(family);
		if (f.isRanged)
		{
			f.doRange(evt.attacker, evt.target, this);
			evt.isHandled = true;
		}
	}
}
