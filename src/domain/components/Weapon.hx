package domain.components;

import data.WeaponFamilyType;
import domain.events.MeleeEvent;
import domain.weapons.Weapons;
import ecs.Component;
import hxd.Rand;

class Weapon extends Component
{
	public var family:WeaponFamilyType;
	public var die:Int = 6;
	public var modifier:Int = 0;
	public var accuracy:Int = 0;
	public var baseCost:Int = 50;

	public function new(family:WeaponFamilyType)
	{
		this.family = family;
		addHandler(MeleeEvent, (evt) -> onMelee(cast evt));
	}

	public function onMelee(evt:MeleeEvent)
	{
		Weapons.Get(family).doMelee(evt.attacker, evt.defender, this);
	}
}
