package screens.shooting;

import domain.components.Weapon;
import domain.events.QueryEquippedWeaponsEvent;
import domain.events.ShootEvent;
import ecs.Entity;
import screens.target.TargetScreen;

class BasicShootingScreen extends ShootingScreen
{
	var weapon(get, never):Weapon;

	public function new(shooter:Entity)
	{
		this.shooter = shooter;
		super(shooter, {
			weapon: weapon,
			onConfirm: fireShot,
			onCancel: () -> game.screens.pop(),
		});
	}

	private function fireShot(target:TargetResult)
	{
		if (weapon == null)
		{
			return;
		}

		weapon.entity.fireEvent(new ShootEvent(target.cursor, shooter));
	}

	function get_weapon():Weapon
	{
		var evt = shooter.fireEvent(new QueryEquippedWeaponsEvent());
		var w = evt.getPrimaryRanged();

		return w.weapon;
	}
}
