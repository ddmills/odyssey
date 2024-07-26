package domain;

import common.algorithm.Distance;
import common.struct.IntPoint;
import core.Game;
import domain.components.IsPlayer;
import domain.components.Weapon;
import domain.stats.Stats;
import domain.weapons.Weapons;
import ecs.Entity;

class GameMath
{
	public static var XP_REQ_CAP = 3000;
	public static var XP_LVL_INTENSITY = 10;
	public static var XP_BASE_GAIN = 100;
	public static var XP_SPREAD = 3;
	public static var XP_POWER = 2.5;

	public static function GetMaxHealth(level:Int, fortitudeStat:Int):Int
	{
		return 10 + level * 10 + fortitudeStat * 10;
	}

	public static function GetMaxArmor(level:Int, armorStat:Int):Int
	{
		return 5 + level * 5 + armorStat * 5;
	}

	public static function GetArmorRegenRatePerTurn(armorRegenStat:Int):Int
	{
		return 4 + armorRegenStat;
	}

	// note: 1 turn = 100 ticks. Waiting = 500 ticks
	public static function GetArmorRegenDelay(armorRegenStat:Int):Int
	{
		return 500 * 8;
	}

	public static function GetLevelXpReq(level:Int):Int
	{
		return ((level * XP_REQ_CAP) / (level + XP_LVL_INTENSITY)).floor();
	}

	public static function GetXpGain(level:Int, enemy:Int):Int
	{
		return (Math.pow(Math.max(0, ((XP_SPREAD + 1) + (enemy - level))) / (XP_SPREAD + 1), XP_POWER) * XP_BASE_GAIN).floor();
	}

	public static function GetTargetDistance(source:IntPoint, target:IntPoint)
	{
		return Distance.Diagonal(source, target).floor();
	}

	public static function GetRangePenalty(source:IntPoint, target:IntPoint, weaponRange:Int)
	{
		var distance = GetTargetDistance(source, target);
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

		// TODO. the +6 is just random
		return Stats.GetValue(wpnFamily.stat, attacker) + weapon.accuracy - rangePenalty + 6;
	}

	public static function GetMeleeAttackToHit(attacker:Entity, weapon:Weapon)
	{
		var wpnFamily = Weapons.Get(weapon.family);

		// TODO. the +6 is just random
		return Stats.GetValue(wpnFamily.stat, attacker) + weapon.accuracy + 6;
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

		var dodge = Stats.GetValue(STAT_DODGE, defender);
		var difference = toHit - dodge;
		var faces = [for (i in 0...dieSize) (i + 1)];
		var critAllowed = attacker.has(IsPlayer);

		return faces.avg((d) ->
		{
			if (critAllowed && d == dieSize)
			{
				return 1;
			}
			var n = (d + difference).clamp(0, dieSize) / dieSize;

			return n;
		});
	}
}
