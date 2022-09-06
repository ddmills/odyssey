package domain.prefabs;

import data.SoundResources;
import data.TileResources;
import domain.components.Equipment;
import domain.components.EquippedSkillMod;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class DusterPrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var duster = new Entity();
		duster.add(new Sprite(TileResources.DUSTER, 0x97621C, 0x080604, OBJECTS));
		duster.add(new Moniker('Duster'));
		duster.add(new Loot());
		duster.add(new Equipment([EQ_SLOT_BODY]));

		var skills = new EquippedSkillMod();
		skills.set(SKILL_FORTITUDE, 2);

		duster.add(skills);

		duster.get(Equipment).equipSound = SoundResources.CLOTH_EQUIP_1;
		duster.get(Equipment).unequipSound = SoundResources.CLOTH_UNEQUIP_1;

		return duster;
	}
}
