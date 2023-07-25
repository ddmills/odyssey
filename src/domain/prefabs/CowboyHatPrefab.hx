package domain.prefabs;

import data.ColorKey;
import domain.components.Destructable;
import domain.components.Equipment;
import domain.components.EquippedSkillMod;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class CowboyHatPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(COWBOY_HAT_1, C_RED_2, C_YELLOW_1, OBJECTS));
		entity.add(new Moniker('Cowboy hat'));
		entity.add(new Equipment([EQ_SLOT_HEAD]));
		entity.add(new Loot());
		entity.add(new Destructable());

		var skills = new EquippedSkillMod();
		skills.set(SKILL_DODGE, 1);
		entity.add(skills);

		return entity;
	}
}
