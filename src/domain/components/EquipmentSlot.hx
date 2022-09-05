package domain.components;

import data.EquipmentSlotType;
import domain.events.QuerySkillModEquippedEvent;
import domain.events.QuerySkillModEvent;
import ecs.Component;
import ecs.Entity;

class EquipmentSlot extends Component
{
	static var allowMultiple = true;

	private var _contentId:String = '';

	public var name:String;
	public var slotKey:String;
	public var slotType:EquipmentSlotType;
	public var content(get, never):Entity;
	public var isEmpty(get, never):Bool;

	public function new(name:String, slotKey:String, slotType:EquipmentSlotType)
	{
		this.name = name;
		this.slotKey = slotKey;
		this.slotType = slotType;
		addHandler(QuerySkillModEvent, (evt) -> onQuerySkillMod(cast evt));
	}

	public function onQuerySkillMod(evt:QuerySkillModEvent)
	{
		if (content == null)
		{
			return;
		}

		var equipped = new QuerySkillModEquippedEvent(evt.skill);
		equipped.mods = evt.mods;

		content.fireEvent(equipped);
	}

	public function unequip()
	{
		if (isEmpty)
		{
			return false;
		}

		var c = content;
		_contentId = '';

		c.remove(IsEquipped);

		return true;
	}

	public function equip(equipment:Entity)
	{
		equipment.get(Loot).take(entity);
		equipment.add(new IsEquipped(entity.id, slotKey));
		_contentId = equipment.id;
	}

	function get_content():Entity
	{
		return entity.registry.getEntity(_contentId);
	}

	function set_content(value:Entity):Entity
	{
		_contentId = value == null ? '' : value.id;

		return value;
	}

	function get_isEmpty():Bool
	{
		return content == null;
	}
}
