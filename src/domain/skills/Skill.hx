package domain.skills;

import data.SkillType;
import domain.stats.StatModifier;
import ecs.Entity;

class Skill
{
	public var type:SkillType;
	public var name:String;

	public function new(type:SkillType, name:String)
	{
		this.type = type;
		this.name = name;
	}

	public function getStatModifiers():Array<StatModifier>
	{
		return [];
	}

	public function getCost():Int
	{
		return 120;
	}
}
