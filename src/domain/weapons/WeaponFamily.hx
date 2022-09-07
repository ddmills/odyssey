package domain.weapons;

import common.struct.IntPoint;
import core.Game;
import data.AmmoType;
import data.SkillType;
import data.SoundResources;
import domain.components.Bullet;
import domain.components.Energy;
import domain.components.Health;
import domain.components.IsPlayer;
import domain.components.Move;
import domain.components.Weapon;
import domain.events.AttackedEvent;
import domain.prefabs.Spawner;
import domain.skills.Skills;
import ecs.Entity;
import hxd.Rand;
import hxd.res.Sound;

class WeaponFamily
{
	public var isRanged:Bool;
	public var skill:SkillType;
	public var ammo:Null<AmmoType>;

	public function getSound():Sound
	{
		return Rand.create().pick([SoundResources.SHOT_PISTOL_1, SoundResources.SHOT_PISTOL_2]);
	}

	public function getAttacks(attacker:Entity, weapon:Weapon):Array<Attack>
	{
		var r = Rand.create();
		var roll = r.roll(Game.instance.DIE_SIZE);
		var skill = Skills.GetValue(skill, attacker);
		var toHit = weapon.accuracy + skill + roll;
		var damage = r.roll(weapon.die, weapon.modifier) + skill;
		var isCritical = attacker.has(IsPlayer) && roll == Game.instance.DIE_SIZE;

		return [
			{
				attacker: attacker,
				toHit: toHit,
				damage: damage,
				isCritical: isCritical,
			}
		];
	}

	public function doRangeNoAmmo(attacker:Entity, weapon:Weapon)
	{
		if (attacker.has(IsPlayer))
		{
			Game.instance.world.playAudio(attacker.pos.toIntPoint(), SoundResources.SHOOT_NO_AMMO_1);
		}
	}

	public function doRange(attacker:Entity, target:IntPoint, weapon:Weapon)
	{
		getAttacks(attacker, weapon).each((attack:Attack) ->
		{
			if (!weapon.isLoaded)
			{
				doRangeNoAmmo(attacker, weapon);
				return;
			}

			weapon.ammo -= 1;

			var defender = Game.instance.world.getEntitiesAt(target).find((e) -> e.has(Health));
			var isHit = false;
			if (defender != null)
			{
				isHit = defender.fireEvent(new AttackedEvent(attack)).isHit;
			}

			var bullet = Spawner.Spawn(BULLET, attack.attacker.pos);
			bullet.add(new Move(target.asWorld(), .6, LINEAR));

			var shot = getSound();
			Game.instance.world.playAudio(attacker.pos.toIntPoint(), shot);
			if (isHit)
			{
				bullet.get(Bullet).impactSound = Rand.create().pick([
					SoundResources.IMPACT_FLESH_1,
					SoundResources.IMPACT_FLESH_2,
					SoundResources.IMPACT_FLESH_3
				]);
			}
		});
		attacker.get(Energy).consumeEnergy(weapon.baseCost);
	}

	public function doMelee(attacker:Entity, defender:Entity, weapon:Weapon)
	{
		attacker.get(Energy).consumeEnergy(weapon.baseCost);
		var r = Rand.create();
		var roll = r.roll(Game.instance.DIE_SIZE);
		var skill = Skills.GetValue(skill, attacker);
		var toHit = weapon.accuracy + skill + roll;
		var damage = r.roll(weapon.die, weapon.modifier) + skill;
		var isCritical = attacker.has(IsPlayer) && roll == Game.instance.DIE_SIZE;

		getAttacks(attacker, weapon).each((attack:Attack) ->
		{
			defender.fireEvent(new AttackedEvent({
				attacker: attacker,
				toHit: toHit,
				damage: damage,
				isCritical: isCritical,
			}));
		});
	}
}
