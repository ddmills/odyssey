package domain.components;

import data.AttributeType;
import data.SkillType;
import domain.events.LevelUpEvent;
import domain.events.QueryStatModEvent;
import domain.skills.Skills;
import ecs.Component;
import ecs.Entity;

class Attributes extends Component
{
	@save public var grit:Int = 0;
	@save public var savvy:Int = 0;
	@save public var finesse:Int = 0;
	@save public var skills:Array<SkillType> = [];
	@save public var freeSkills:Array<SkillType> = [];

	public function new(grit:Int = 0, savvy:Int = 0, finesse:Int = 0)
	{
		this.grit = grit;
		this.savvy = savvy;
		this.finesse = finesse;

		addHandler(QueryStatModEvent, onQueryStatMod);
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

	public function getUnspentAttributePoints():Int
	{
		var level = entity.get(Level).level;
		var total = GameMath.GetAttributePointTotal(level);
		var spent = grit + savvy + finesse;
		return (total - spent).clampLower(0);
	}

	public function getUnspentSkillPoints():Int
	{
		var level = entity.get(Level).level;
		var total = GameMath.GetSkillPointTotal(entity, level);
		var spent = skills.sum((s) ->
		{
			if (freeSkills.contains(s))
			{
				return 0;
			}

			return Skills.Get(s).getCost();
		}).round();

		return (total - spent).clampLower(0);
	}

	public function incrementAttribute(attribute:AttributeType):Bool
	{
		var unspentAttributePoints = getUnspentAttributePoints();

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

		return true;
	}

	public function unlockSkill(skill:SkillType, isFree:Bool)
	{
		if (!skills.contains(skill))
		{
			skills.push(skill);
		}

		if (isFree && !freeSkills.contains(skill))
		{
			freeSkills.push(skill);
		}
	}

	private function onQueryStatMod(evt:QueryStatModEvent)
	{
		for (skill in skills)
		{
			var mods = Skills.Get(skill)
				.getStatModifiers()
				.filter((mod) -> mod.stat == evt.stat);

			evt.addMods(mods);
		}
	}
}
