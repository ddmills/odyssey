package domain.prefabs;

import data.ColorKey;
import domain.components.Energy;
import domain.components.EquipmentSlot;
import domain.components.FactionMember;
import domain.components.Health;
import domain.components.Inventory;
import domain.components.IsEnemy;
import domain.components.Level;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Stats;
import ecs.Entity;

class SnakePrefab extends Prefab
{
	public function Create(options:Dynamic)
	{
		var entity = new Entity();

		entity.add(new Sprite(SNAKE, C_ORANGE_1, C_BLACK_1, ACTORS));
		entity.add(new Energy());
		entity.add(new Level(1));
		entity.add(new FactionMember(FACTION_WILDLIFE));
		entity.get(Energy).consumeEnergy(10);
		entity.add(new Health());
		entity.add(new Stats(0, 1, 2));
		entity.add(new IsEnemy());
		entity.add(new Moniker('Rattlesnake'));
		entity.add(new Inventory());
		entity.add(new EquipmentSlot('head', 'face', EQ_SLOT_HAND, true));

		entity.get(Health).corpsePrefab = CORPSE_SNAKE;

		entity.get(EquipmentSlot).equip(Spawner.Spawn(STICK));

		entity.get(Inventory).isOpenable = false;

		return entity;
	}
}
