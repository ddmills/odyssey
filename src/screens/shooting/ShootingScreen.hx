package screens.shooting;

import core.Frame;
import core.input.Command;
import domain.components.Health;
import domain.components.IsDestroyed;
import domain.components.IsEnemy;
import domain.components.IsInventoried;
import domain.components.Visible;
import domain.components.Weapon;
import domain.events.ReloadEvent;
import domain.events.ShootEvent;
import domain.weapons.Weapons;
import ecs.Entity;
import ecs.Query;
import screens.target.TargetScreen;
import screens.target.footprints.EmptyFootprint;

typedef ShootingScreenSettings =
{
	weapon:Weapon,
	onConfirm:(result:TargetResult) -> Void,
	onCancel:() -> Void,
}

class ShootingScreen extends TargetScreen
{
	var shooter:Entity;
	var shootingSettings:ShootingScreenSettings;

	public function new(shooter:Entity, shootingSettings:ShootingScreenSettings)
	{
		this.shooter = shooter;
		this.shootingSettings = shootingSettings;
		var targetQuery = new Query({
			all: [Visible, Health, IsEnemy],
			none: [IsInventoried, IsDestroyed],
		});

		var weapon = shootingSettings.weapon;

		var fp = weapon == null ? new EmptyFootprint() : Weapons.Get(weapon.family).getFootprint();

		super(shooter, {
			origin: TARGETER,
			footprint: fp,
			targetQuery: targetQuery,
			showFootprint: true,
			onConfirm: tryShoot,
			onCancel: shootingSettings.onCancel,
		});
	}

	override function update(frame:Frame)
	{
		if (shootingSettings.weapon == null)
		{
			game.screens.pop();
		}

		super.update(frame);
	}

	private function tryShoot(target:TargetResult)
	{
		if (shootingSettings.weapon == null)
		{
			return;
		}

		shootingSettings.onConfirm(target);
	}

	function tryReload()
	{
		if (shootingSettings.weapon == null)
		{
			return;
		}

		shootingSettings.weapon.entity.fireEvent(new ReloadEvent(shooter));
	}

	override function handleInput(command:Command)
	{
		switch (command.type)
		{
			case CMD_RELOAD:
				tryReload();
			case _:
				super.handleInput(command);
		}
	}
}
