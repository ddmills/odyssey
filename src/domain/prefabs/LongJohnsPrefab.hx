package domain.prefabs;

import data.SoundResources;
import data.TileResources;
import domain.components.Equipment;
import domain.components.EquippedSkillMod;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class LongJohnsPrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var longJohns = new Entity();

		longJohns.add(new Sprite(TileResources.LONG_JOHNS, 0xE0CCB2, 0x97621C, OBJECTS));
		longJohns.add(new Moniker('Long johns'));
		longJohns.add(new Loot());
		longJohns.add(new Equipment([EQ_SLOT_BODY], [EQ_SLOT_LEGS]));
		var skills = new EquippedSkillMod();
		skills.set(SKILL_MAX_HEALTH, 2);
		longJohns.add(skills);
		longJohns.get(Equipment).equipSound = SoundResources.CLOTH_EQUIP_1;
		longJohns.get(Equipment).unequipSound = SoundResources.CLOTH_UNEQUIP_1;
		return longJohns;
	}
}
