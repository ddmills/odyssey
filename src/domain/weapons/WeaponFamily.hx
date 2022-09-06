package domain.weapons;

import common.struct.IntPoint;
import core.Game;
import data.SkillType;
import domain.components.Energy;
import domain.components.Health;
import domain.components.Move;
import domain.components.Weapon;
import domain.events.AttackedEvent;
import domain.prefabs.Spawner;
import domain.skills.Skills;
import ecs.Entity;
import hxd.Rand;

class WeaponFamily
{
	public var isRanged:Bool;
	public var skill:SkillType;

	public function getAttacks(attacker:Entity, weapon:Weapon):Array<Attack>
	{
		var r = Rand.create();
		var roll = r.roll(6);
		var skill = Skills.getValue(skill, attacker);
		var toHit = weapon.accuracy + skill + roll;
		var damage = r.roll(weapon.die, weapon.modifier) + skill;
		var isCritical = roll == 6;

		return [
			{
				attacker: attacker,
				toHit: toHit,
				damage: damage,
				isCritical: isCritical,
			}
		];
	}

	public function doRange(attacker:Entity, target:IntPoint, weapon:Weapon)
	{
		if (!isRanged)
		{
			trace('!');
			return;
		}
		getAttacks(attacker, weapon).each((attack:Attack) ->
		{
			var bullet = Spawner.Spawn(BULLET, attack.attacker.pos);
			bullet.add(new Move(target.asWorld(), .6, LINEAR));

			var defender = Game.instance.world.getEntitiesAt(target).find((e) -> e.has(Health));
			if (defender != null)
			{
				defender.fireEvent(new AttackedEvent(attack));
			}
		});
		attacker.get(Energy).consumeEnergy(weapon.baseCost);
	}

	public function doMelee(attacker:Entity, defender:Entity, weapon:Weapon)
	{
		attacker.get(Energy).consumeEnergy(weapon.baseCost);
		var r = Rand.create();
		var roll = r.roll(6);
		var skill = Skills.getValue(skill, attacker);
		var toHit = weapon.accuracy + skill + roll;
		var damage = r.roll(weapon.die, weapon.modifier) + skill;
		var isCritical = roll == 6;

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
