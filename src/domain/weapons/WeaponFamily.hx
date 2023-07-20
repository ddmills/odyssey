package domain.weapons;

import common.struct.IntPoint;
import core.Game;
import data.AmmoType;
import data.AudioKey;
import data.SkillType;
import domain.components.Bullet;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.components.IsPlayer;
import domain.components.Moniker;
import domain.components.Move;
import domain.components.Weapon;
import domain.events.AttackedEvent;
import domain.events.ConsumeEnergyEvent;
import domain.prefabs.Spawner;
import domain.skills.Skills;
import ecs.Entity;
import hxd.Rand;
import screens.target.footprints.CircleFootprint;
import screens.target.footprints.Footprint;

class WeaponFamily
{
	public var isRanged:Bool;
	public var skill:SkillType;
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
			var entities = Game.instance.world.getEntitiesAt(p);
			for (e in entities)
			{
				if (e != attacker && !e.has(IsInventoried) && !e.has(IsDestroyed))
				{
					var roll = r.roll(Game.instance.DIE_SIZE);
					var toHit = roll + GameMath.GetRangedAttackToHit(attacker, target, weapon) + 100; // todo
					var skillValue = Skills.GetValue(skill, attacker);
					var damage = r.roll(weapon.die, weapon.modifier) + skillValue;
					var isCritical = attacker.has(IsPlayer) && roll == Game.instance.DIE_SIZE;

					trace('push attack', toHit, damage);

					if (e.has(Moniker))
					{
						trace(e.get(Moniker).displayName);
					}

					// todo: do we actually have a clear trajectory to the target?
					attacks.push({
						attacker: attacker,
						toHit: toHit,
						damage: damage,
						isCritical: isCritical,
						defender: e,
					});
				}
			}
		}

		return attacks;
	}

	public function getFootprint():Footprint
	{
		return new CircleFootprint(1);
	}

	public function getMeleeAttacks(attacker:Entity, weapon:Weapon):Array<Attack>
	{
		var r = Rand.create();
		var roll = r.roll(Game.instance.DIE_SIZE);
		var toHit = roll + GameMath.GetMeleeAttackToHit(attacker, weapon);
		var skill = Skills.GetValue(skill, attacker);
		var damage = r.roll(weapon.die, weapon.modifier) + skill;
		var isCritical = attacker.has(IsPlayer) && roll == Game.instance.DIE_SIZE;

		return [
			{
				attacker: attacker,
				toHit: toHit,
				damage: damage,
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

		getRangedAttacks(attacker, target, weapon).each((attack:Attack) ->
		{
			var defender = attack.defender;
			var isHit = false;

			if (defender != null)
			{
				isHit = defender.fireEvent(new AttackedEvent(attack)).isHit;
			}

			var bullet = Spawner.Spawn(BULLET, attack.attacker.pos);
			bullet.add(new Move(target.asWorld(), .9, LINEAR));

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
