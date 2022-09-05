package domain.components;

import data.WeaponFamilyType;
import ecs.Component;

class Weapon extends Component
{
	public var family:WeaponFamilyType;
	public var die:Int = 6;
	public var modifier:Int = 0;
	public var baseCost:Int = 100;

	public function new(family:WeaponFamilyType)
	{
		this.family = family;
	}
}
