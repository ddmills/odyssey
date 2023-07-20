package screens.shooting;

import common.struct.Coordinate;
import core.Frame;
import core.input.Command;
import domain.components.EquipmentSlot;
import domain.components.Weapon;
import domain.events.ReloadEvent;
import domain.events.ShootEvent;
import domain.weapons.Weapons;
import ecs.Entity;
import screens.target.TargetScreen;

class ShootingScreen extends TargetScreen
{
	var shooter:Entity;
	var weapon(get, never):Weapon;

	public function new(shooter:Entity)
	{
		this.shooter = shooter;
		var footprint = Weapons.Get(weapon.family).getFootprint();

		super(shooter, {
			origin: TARGETER,
			footprint: footprint,
		});
	}

	override function update(frame:Frame)
	{
		world.updateSystems();
		super.update(frame);

		if (world.systems.energy.isPlayersTurn)
		{
			var cmd = game.commands.peek();
			if (cmd != null)
			{
				handleInput(game.commands.next());
			}
		}
	}

	private function tryShoot(target:TargetResult)
	{
		if (weapon == null)
		{
			return;
		}

		weapon.entity.fireEvent(new ShootEvent(target.cursor, shooter));
	}

	function tryReload()
	{
		if (weapon == null)
		{
			return;
		}

		weapon.entity.fireEvent(new ReloadEvent(shooter));
	}

	function handleInput(command:Command)
	{
		switch (command.type)
		{
			case CMD_CANCEL:
				game.screens.pop();
			case CMD_CONFIRM:
				tryShoot(result);
			case CMD_RELOAD:
				tryReload();
			case _:
		}
	}

	override function onMouseDown(pos:Coordinate)
	{
		tryShoot(result);
	}

	function get_weapon():Weapon
	{
		var weapons = shooter.getAll(EquipmentSlot).filter((s) ->
		{
			if (s.isEmpty || s.isExtraSlot || !s.isPrimary)
			{
				return false;
			}

			var wpn = s.content.get(Weapon);

			if (wpn == null)
			{
				return false;
			}

			return Weapons.Get(wpn.family).isRanged;
		}).map((s) -> s.content.get(Weapon));

		return weapons.first();
	}
}
