package screens.shooting;

import domain.components.Weapon;
import domain.events.QueryEquippedWeaponsEvent;
import domain.events.ShootEvent;
import ecs.Entity;
import screens.target.TargetScreen;

class BasicShootingScreen extends ShootingScreen
{
	var primaryWeapon(get, never):Weapon;
	var offhandWeapons(get, never):Array<Weapon>;

	public function new(shooter:Entity)
	{
		this.shooter = shooter;

		super(shooter, {
			primaryWeapon: primaryWeapon,
			offhandWeapons: offhandWeapons,
			onConfirm: onConfirmShot,
			onCancel: () -> game.screens.pop(),
		});
	}

	private function onConfirmShot(target:TargetResult)
	{
		if (primaryWeapon != null)
		{
			primaryWeapon.entity.fireEvent(new ShootEvent(target.cursor, shooter));
		}

		for (weapon in offhandWeapons)
		{
			trace('shoot offhand weapon');
			weapon.entity.fireEvent(new ShootEvent(target.cursor, shooter));
		}
	}

	function get_primaryWeapon():Weapon
	{
		var evt = shooter.fireEvent(new QueryEquippedWeaponsEvent());
		var w = evt.getPrimaryRanged();

		if (w == null)
		{
			return null;
		}

		return w.weapon;
	}

	function get_offhandWeapons():Array<Weapon>
	{
		var evt = shooter.fireEvent(new QueryEquippedWeaponsEvent());
		var w = evt.getOffhandRanged();

		return w.map((w) -> w.weapon);
	}
}
