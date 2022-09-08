package domain;

import core.Game;
import domain.components.IsPlayer;
import domain.components.Weapon;
import domain.skills.Skills;
import domain.weapons.Weapons;
import ecs.Entity;

class GameMath
{
	public static function GetToHit(attacker:Entity, defender:Entity, weapon:Weapon)
	{
		var dieSize = Game.instance.DIE_SIZE;
		var wpnFamily = Weapons.Get(weapon.family);
		var toHit = Skills.GetValue(wpnFamily.skill, attacker) + weapon.accuracy;
		var dodge = Skills.GetValue(SKILL_DODGE, defender);
		var difference = toHit - dodge;
		var faces = [for (i in 0...dieSize) (i + 1)];
		var critAllowed = attacker.has(IsPlayer);

		var chance = faces.avg((d) ->
		{
			if (critAllowed && d == dieSize)
			{
				return 1;
			}
			var n = (d + difference).clamp(0, dieSize) / dieSize;

			return n;
		});

		return chance;
	}
}
