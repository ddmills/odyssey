package domain.components;

import data.AttributeType;
import domain.events.LevelUpEvent;
import ecs.Component;
import ecs.Entity;

class Attributes extends Component
{
	@save public var grit:Int = 0;
	@save public var savvy:Int = 0;
	@save public var finesse:Int = 0;
	@save public var unspentAttributePoints:Int = 2;

	public function new(grit:Int = 0, savvy:Int = 0, finesse:Int = 0)
	{
		this.grit = grit;
		this.savvy = savvy;
		this.finesse = finesse;
		addHandler(LevelUpEvent, onLevelUp);
	}

	public function incrementAttribute(attribute:AttributeType)
	{
		if (unspentAttributePoints <= 0)
		{
			return false;
		}

		switch attribute
		{
			case GRIT:
				grit++;
			case SAVVY:
				savvy++;
			case FINESSE:
				finesse++;
		}
		unspentAttributePoints--;

		return true;
	}

	public function get(attributes:AttributeType)
	{
		return switch attributes
		{
			case GRIT: grit;
			case SAVVY: savvy;
			case FINESSE: finesse;
		}
	}

	public static function Get(e:Entity, type:AttributeType):Int
	{
		var attributes = e.get(Attributes);

		if (attributes == null)
		{
			return 0;
		}

		return attributes.get(type);
	}

	public static function GetAll(e:Entity):Array<{attribute:AttributeType, value:Int}>
	{
		var attributes = e.get(Attributes);

		if (attributes == null)
		{
			return [];
		}

		return [
			{attribute: GRIT, value: attributes.grit},
			{attribute: SAVVY, value: attributes.savvy},
			{attribute: FINESSE, value: attributes.finesse},
		];
	}

	function onLevelUp(evt:LevelUpEvent)
	{
		unspentAttributePoints++;
	}
}
