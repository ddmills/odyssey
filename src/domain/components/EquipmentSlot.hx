package domain.components;

import data.EquipmentSlotType;
import data.WeaponFamilyType;
import domain.events.MeleeEvent;
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
	public var isPrimary:Bool;
	public var defaultWpn:WeaponFamilyType;
	public var content(get, never):Entity;
	public var isEmpty(get, never):Bool;
	public var isExtraSlot(get, never):Bool;
	public var displayName(get, never):String;
	public var contentDisplay(get, never):String;

	public function new(name:String, slotKey:String, slotType:EquipmentSlotType, isPrimary:Bool = false, ?defaultWpn:WeaponFamilyType)
	{
		this.name = name;
		this.slotKey = slotKey;
		this.slotType = slotType;
		this.isPrimary = isPrimary;
		this.defaultWpn = defaultWpn;
		addHandler(QuerySkillModEvent, (evt) -> onQuerySkillMod(cast evt));
		addHandler(MeleeEvent, (evt) -> onMelee(cast evt));
	}

	private function onMelee(evt:MeleeEvent)
	{
		if (isEmpty)
		{
			if (defaultWpn != null)
			{
				trace('use default weapon!', defaultWpn);
			}
			return;
		}

		if (isPrimary && !isExtraSlot)
		{
			content.fireEvent(evt);
		}
	}

	private function onQuerySkillMod(evt:QuerySkillModEvent)
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
		var equipped = c.get(IsEquipped);

		if (equipped.extraSlotKey != null)
		{
			if (equipped.extraSlot == this)
			{
				equipped.slot.unequip();
			}
			else
			{
				equipped.extraSlot.unequip();
			}
		}

		c.remove(IsEquipped);

		return true;
	}

	public function unequipSecondary()
	{
		_contentId = '';
	}

	public function equipSecondary(equipment:Entity)
	{
		unequip();
		_contentId = equipment.id;
	}

	public function equip(equipment:Entity)
	{
		unequip();
		var eq = equipment.get(Equipment);
		var extraSlotKey:String = null;

		if (eq.extraSlotTypes.length > 0)
		{
			var extraSlot = entity.getAll(EquipmentSlot)
				.find((s) -> eq.extraSlotTypes.contains(s.slotType) && s.slotKey != slotKey);

			extraSlotKey = extraSlot.slotKey;
			extraSlot.equipSecondary(equipment);
		}

		equipment.get(Loot).take(entity);
		equipment.add(new IsEquipped(entity.id, slotKey, extraSlotKey));

		_contentId = equipment.id;
	}

	function get_content():Entity
	{
		return entity.registry.getEntity(_contentId);
	}

	function get_isEmpty():Bool
	{
		return content == null;
	}

	function get_displayName():String
	{
		return '$name $contentDisplay';
	}

	function get_contentDisplay():String
	{
		if (isEmpty)
		{
			return '[empty]';
		}

		return '[${content.get(Moniker).baseName}]';
	}

	function get_isExtraSlot():Bool
	{
		if (isEmpty)
		{
			return false;
		}

		var equipped = content.get(IsEquipped);
		return equipped.extraSlot == this;
	}
}
