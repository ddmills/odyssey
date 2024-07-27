package domain.abilities;

import core.Game;
import domain.components.Weapon;
import domain.events.QueryEquippedWeaponsEvent;
import domain.events.ShootEvent;
import ecs.Entity;
import screens.shooting.ShootingScreen;

class AbilityBarrage extends Ability
{
	public function new()
	{
		super(ABILITY_BARRAGE, ABL_MODE_ACTIVATED, "Barrage");
	}

	public override function getDescription(entity:Entity):String
	{
		return "Fire the remaining bullets in your pistol at a target with reduced accuracy.";
	}

	public override function isRequirementsMet(entity:Entity):Bool
	{
		var pistol = getPrimaryPistol(entity);

		// must be weilding a pistol in primary
		return pistol != null;
	}

	public override function initiate(entity:Entity)
	{
		trace("Initiate barrage!");
		var pistol = getPrimaryPistol(entity);

		// if player, push screen, if AI, choose target
		Game.instance.screens.push(new ShootingScreen(entity, {
			weapon: pistol,
			onConfirm: (target) ->
			{
				while (pistol.isLoaded)
				{
					pistol.entity.fireEvent(new ShootEvent(target.cursor, entity));
				}

				Game.instance.screens.pop();
			},
			onCancel: () -> Game.instance.screens.pop(),
		}));
	}

	function getPrimaryPistol(entity:Entity):Weapon
	{
		var evt = entity.fireEvent(new QueryEquippedWeaponsEvent());
		var w = evt.getPrimaryRanged();

		if (w.weapon.family == WPN_FAMILY_PISTOL)
		{
			return w.weapon;
		}

		return null;
	}
}
