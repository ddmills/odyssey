package domain.prefabs;

import data.ColorKey;
import domain.components.Destructable;
import domain.components.Equipment;
import domain.components.EquippedSkillMod;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class BootsPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(BOOTS, C_ORANGE_2, C_GRAY_5, OBJECTS));
		entity.add(new Moniker('Boots'));
		entity.add(new Equipment([EQ_SLOT_FEET]));
		entity.add(new Loot());

		var skills = new EquippedSkillMod();
		skills.set(SKILL_SPEED, 2);
		entity.add(skills);

		entity.add(new Destructable());

		return entity;
	}
}
