package domain.prefabs;

import data.ColorKeys;
import domain.components.Equipment;
import domain.components.EquippedSkillMod;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class DusterPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var duster = new Entity();
		duster.add(new Sprite(DUSTER, ColorKeys.C_RED_2, ColorKeys.C_GRAY_5, OBJECTS));
		duster.add(new Moniker('Duster'));
		duster.add(new Loot());
		duster.add(new Equipment([EQ_SLOT_BODY]));

		var skills = new EquippedSkillMod();
		skills.set(SKILL_FORTITUDE, 2);

		duster.add(skills);

		duster.get(Equipment).equipAudio = CLOTH_EQUIP_1;
		duster.get(Equipment).unequipAudio = CLOTH_UNEQUIP_1;

		return duster;
	}
}
