package domain.weapons;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Game;
import data.AmmoType;
import data.AudioKey;
import data.StatType;
import domain.components.Bullet;
import domain.components.Health;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.components.IsPlayer;
import domain.components.Move;
import domain.components.Tracer;
import domain.components.Weapon;
import domain.events.AttackedEvent;
import domain.events.ConsumeEnergyEvent;
import domain.prefabs.Spawner;
import domain.stats.Stats;
import ecs.Entity;
import hxd.Rand;
import screens.target.footprints.Footprint;
import screens.target.footprints.PointFootprint;

class WeaponFamily
{
	public var isRanged:Bool;
	public var stat:StatType;
	public var ammo:Null<AmmoType>;

	public function getSound():AudioKey
	{
		return Rand.create().pick([SHOT_PISTOL_1, SHOT_PISTOL_2]);
	}

	public function getRangedAttacks(attacker:Entity, target:IntPoint, weapon:Weapon):Array<Attack>
	{
		var r = Rand.create();
		var footprint = getFootprint();
		var aoe = footprint.getFootprint(attacker.pos, target.asWorld());
		var attacks = new Array<Attack>();

		for (p in aoe)
		{
			var hitEntity = false;
			var entities = Game.instance.world.getEntitiesAt(p);

			var roll = r.roll(Game.instance.DIE_SIZE);
			var toHit = roll + GameMath.GetRangedAttackToHit(attacker, target, weapon);
			var statValue = Stats.GetValue(stat, attacker);
			var damage = r.roll(weapon.die, weapon.modifier) + statValue;
			var isCritical = attacker.has(IsPlayer) && roll == Game.instance.DIE_SIZE;

			for (e in entities)
			{
				if (e != attacker && e.has(Health) && !e.has(IsInventoried) && !e.has(IsDestroyed))
				{
					hitEntity = true;

					// todo: do we actually have a clear trajectory to the target?
					attacks.push({
						attacker: attacker,
						toHit: toHit,
						damage: damage,
						damageType: DMG_PIERCE,
						isCritical: isCritical,
						defender: e,
					});

					continue;
				}
			}

			if (!hitEntity)
			{
				attacks.push({
					attacker: attacker,
					toHit: toHit,
					damage: damage,
					damageType: DMG_PIERCE,
					isCritical: isCritical,
					defender: null,
				});
			}
		}

		return attacks;
	}

	public function getFootprint():Footprint
	{
		return new PointFootprint();
	}

	public function getMeleeAttacks(attacker:Entity, weapon:Weapon):Array<Attack>
	{
		var r = Rand.create();
		var roll = r.roll(Game.instance.DIE_SIZE);
		var toHit = roll + GameMath.GetMeleeAttackToHit(attacker, weapon);
		var stat = Stats.GetValue(stat, attacker);
		var damage = r.roll(weapon.die, weapon.modifier) + stat;
		var isCritical = attacker.has(IsPlayer) && roll == Game.instance.DIE_SIZE;

		return [
			{
				attacker: attacker,
				toHit: toHit,
				damage: damage,
				damageType: DMG_BLUNT,
				isCritical: isCritical,
				defender: null,
			}
		];
	}

	public function doRangeNoAmmo(attacker:Entity, weapon:Weapon)
	{
		if (attacker.has(IsPlayer))
		{
			Game.instance.world.playAudio(attacker.pos.toIntPoint(), SHOOT_NO_AMMO_1);
		}
	}

	public function doRange(attacker:Entity, target:IntPoint, weapon:Weapon)
	{
		if (!weapon.isLoaded)
		{
			doRangeNoAmmo(attacker, weapon);
			return;
		}

		var r = Rand.create();

		getRangedAttacks(attacker, target, weapon).each((attack:Attack) ->
		{
			var defender = attack.defender;
			var isHit = false;

			if (defender != null)
			{
				isHit = defender.fireEvent(new AttackedEvent(attack)).isHit;
			}

			var bullet = Spawner.Spawn(BULLET, attack.attacker.pos);
			bullet.add(new Move(target.asWorld(), .25, EASE_LINEAR));

			var start = attack.attacker.pos.add(new Coordinate(.5, .5));

			if (attack.isCritical)
			{
				var end = target.asWorld().add(new Coordinate(.5, .5));
				bullet.add(new Tracer(start, end, .3, data.ColorKey.C_YELLOW_3));
			}
			else
			{
				var endX = isHit ? r.float(-1, 1) : r.float(-2, 2);
				var endY = isHit ? r.float(-1, 1) : r.float(-2, 2);

				var end = target.asWorld().add(new Coordinate(endX, endY, WORLD)).add(new Coordinate(.5, .5));
				bullet.add(new Tracer(start, end, .10, data.ColorKey.C_GRAY_1));
			}

			if (isHit)
			{
				bullet.get(Bullet).impactSound = Rand.create().pick([IMPACT_FLESH_1, IMPACT_FLESH_2, IMPACT_FLESH_3]);
			}
		});

		var shot = getSound();
		Game.instance.world.playAudio(attacker.pos.toIntPoint(), shot);
		weapon.ammo -= 1;
		attacker.fireEvent(new ConsumeEnergyEvent(weapon.baseCost));
	}

	public function doMelee(attacker:Entity, defender:Entity, weapon:Weapon)
	{
		getMeleeAttacks(attacker, weapon).each((attack:Attack) ->
		{
			defender.fireEvent(new AttackedEvent(attack));
		});

		attacker.fireEvent(new ConsumeEnergyEvent(weapon.baseCost));
	}
}
