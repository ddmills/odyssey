package domain.prefabs;

import data.TileResources;
import domain.components.Equipment;
import domain.components.EquippedSkillMod;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class PonchoPrefab extends Prefab
{
	public function Create(?options:Dynamic):Entity
	{
		var poncho = new Entity();
		poncho.add(new Sprite(TileResources.PONCHO, 0x3B7443, 0xDAC9BB, OBJECTS));
		poncho.add(new Moniker('Poncho'));
		poncho.add(new Loot());
		poncho.add(new Equipment([EQ_SLOT_BODY]));

		var skills = new EquippedSkillMod();
		skills.set(SKILL_MAX_HEALTH, 2);

		poncho.add(skills);

		return poncho;
	}
}
