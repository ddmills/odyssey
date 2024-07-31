package domain.prefabs.decorators;

import domain.components.EquipmentSlot;
import domain.components.Inventory;
import ecs.Entity;

class HumanoidDecorator
{
	public static function Decorate(entity:Entity)
	{
		entity.add(new Inventory(false));

		entity.add(new EquipmentSlot('Right hand', 'handRight', EQ_SLOT_HAND, true));
		entity.add(new EquipmentSlot('Head', 'head', EQ_SLOT_HEAD));
		entity.add(new EquipmentSlot('Face', 'face', EQ_SLOT_FACE));
		entity.add(new EquipmentSlot('Left hand', 'handLeft', EQ_SLOT_HAND, false));
		entity.add(new EquipmentSlot('Holster', 'holster', EQ_SLOT_HOLSTER));
		entity.add(new EquipmentSlot('Body', 'body', EQ_SLOT_BODY));
		entity.add(new EquipmentSlot('Legs', 'legs', EQ_SLOT_LEGS));
		entity.add(new EquipmentSlot('Feet', 'feet', EQ_SLOT_FEET));
	}
}
