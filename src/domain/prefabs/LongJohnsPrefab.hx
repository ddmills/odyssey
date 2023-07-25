package domain.prefabs;

import data.ColorKey;
import domain.components.Destructable;
import domain.components.Equipment;
import domain.components.EquippedSkillMod;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class LongJohnsPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(LONG_JOHNS, C_WHITE_1, C_GRAY_2, OBJECTS));
		entity.add(new Moniker('Long johns'));
		entity.add(new Loot());
		entity.add(new Equipment([EQ_SLOT_BODY], [EQ_SLOT_LEGS]));
		entity.add(new Destructable());

		var skills = new EquippedSkillMod();
		skills.set(SKILL_FORTITUDE, 2);
		entity.add(skills);
		entity.get(Equipment).equipAudio = CLOTH_EQUIP_1;
		entity.get(Equipment).unequipAudio = CLOTH_UNEQUIP_1;

		return entity;
	}
}
