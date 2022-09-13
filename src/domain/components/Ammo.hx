package domain.components;

import data.AmmoType;
import data.SpawnableType;
import ecs.Component;

class Ammo extends Component
{
	@save public var ammoType:AmmoType;

	public function new(ammoType:AmmoType)
	{
		this.ammoType = ammoType;
	}

	public static function GetSpawnable(ammoType:AmmoType):SpawnableType
	{
		return switch ammoType
		{
			case AMMO_PISTOL: PISTOL_AMMO;
			case AMMO_RIFLE: RIFLE_AMMO;
			case AMMO_SHOTGUN: SHOTGUN_AMMO;
		}
	}
}
