package domain.prefabs;

import domain.components.Equipment;
import domain.components.EquippedSkillMod;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class PonchoPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();
		entity.add(new Sprite(PONCHO, 0x3B7443, 0xDAC9BB, OBJECTS));
		entity.add(new Moniker('Poncho'));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_BODY]));

		var skills = new EquippedSkillMod();
		skills.set(SKILL_FORTITUDE, 2);

		entity.add(skills);

		entity.get(Equipment).equipAudio = CLOTH_EQUIP_1;
		entity.get(Equipment).unequipAudio = CLOTH_UNEQUIP_1;

		return entity;
	}
}
