package domain;

import common.algorithm.Distance;
import common.struct.IntPoint;
import core.Game;
import domain.components.IsPlayer;
import domain.components.Weapon;
import domain.skills.Skills;
import domain.weapons.Weapons;
import ecs.Entity;

class GameMath
{
	public static function GetRangePenalty(source:IntPoint, target:IntPoint, weaponRange:Int)
	{
		var distance = Distance.Euclidean(source, target);
		return (distance - weaponRange).ciel().clamp(0, 50);
	}

	public static function GetRangedAttackToHit(attacker:Entity, target:IntPoint, weapon:Weapon)
	{
		var wpnFamily = Weapons.Get(weapon.family);

		if (!wpnFamily.isRanged)
		{
			return -1000;
		}

		var rangePenalty = GetRangePenalty(attacker.pos.toIntPoint(), target, weapon.range);
		trace(rangePenalty);

		return Skills.GetValue(wpnFamily.skill, attacker) + weapon.accuracy - rangePenalty;
	}

	public static function GetMeleeAttackToHit(attacker:Entity, weapon:Weapon)
	{
		var wpnFamily = Weapons.Get(weapon.family);

		return Skills.GetValue(wpnFamily.skill, attacker) + weapon.accuracy;
	}

	public static function GetHitChance(attacker:Entity, defender:Entity, weapon:Weapon, isRanged = false)
	{
		var dieSize = Game.instance.DIE_SIZE;
		var toHit = 0;

		if (isRanged)
		{
			toHit = GetRangedAttackToHit(attacker, defender.pos.toIntPoint(), weapon);
		}
		else
		{
			toHit = GetMeleeAttackToHit(attacker, weapon);
		}

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
