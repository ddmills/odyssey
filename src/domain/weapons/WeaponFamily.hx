package domain.weapons;

import data.SkillType;
import domain.components.Energy;
import domain.components.Weapon;
import domain.events.AttackedEvent;
import domain.skills.Skills;
import ecs.Entity;
import hxd.Rand;

class WeaponFamily
{
	public var isRanged:Bool;
	public var skill:SkillType;

	public function getAttacks(attacker:Entity, defender:Entity, weapon:Weapon):Array<Attack>
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

	public function doMelee(attacker:Entity, defender:Entity, weapon:Weapon)
	{
		attacker.get(Energy).consumeEnergy(weapon.baseCost);
		getAttacks(attacker, defender, weapon).each((attack:Attack) ->
		{
			defender.fireEvent(new AttackedEvent(attack));
		});
	}
}
