package domain.prefabs;

import data.ColorKeys;
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
		var longJohns = new Entity();

		longJohns.add(new Sprite(LONG_JOHNS, ColorKeys.C_WHITE_1, ColorKeys.C_GRAY_2, OBJECTS));
		longJohns.add(new Moniker('Long johns'));
		longJohns.add(new Loot());
		longJohns.add(new Equipment([EQ_SLOT_BODY], [EQ_SLOT_LEGS]));
		var skills = new EquippedSkillMod();
		skills.set(SKILL_FORTITUDE, 2);
		longJohns.add(skills);
		longJohns.get(Equipment).equipAudio = CLOTH_EQUIP_1;
		longJohns.get(Equipment).unequipAudio = CLOTH_UNEQUIP_1;
		return longJohns;
	}
}
