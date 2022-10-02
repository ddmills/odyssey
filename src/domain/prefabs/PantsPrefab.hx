package domain.prefabs;

import data.ColorKey;
import domain.components.Equipment;
import domain.components.EquippedSkillMod;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;
import h3d.shader.ColorKey;

class PantsPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(PANTS_1, C_ORANGE_2, C_GRAY_2, OBJECTS));
		entity.add(new Moniker('Pants'));
		entity.add(new Equipment([EQ_SLOT_LEGS]));
		entity.add(new Loot());

		var skills = new EquippedSkillMod();
		skills.set(SKILL_DODGE, 1);
		entity.add(skills);

		return entity;
	}
}
