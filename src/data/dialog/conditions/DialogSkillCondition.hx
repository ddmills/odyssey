package data.dialog.conditions;

import data.SkillType;
import domain.skills.Skills;
import haxe.EnumTools;
import screens.dialog.Conversation;

typedef DialogSkillConditionParams =
{
	skill:SkillType,
	?min:Int,
	?max:Int,
};

class DialogSkillCondition extends DialogCondition
{
	public var params:DialogSkillConditionParams;

	public function new(params:DialogSkillConditionParams)
	{
		this.params = params;
	}

	public function check(conversation:Conversation):Bool
	{
		var skill = Skills.GetValue(params.skill, conversation.interactor);

		if (params.max != null && skill > params.max)
		{
			return false;
		}

		if (params.min != null && skill < params.min)
		{
			return false;
		}

		return true;
	}

	public static function FromJson(json:Dynamic):DialogSkillCondition
	{
		var skill = EnumTools.createByName(SkillType, json.skill);

		return new DialogSkillCondition({
			skill: skill,
			min: json.min,
			max: json.max,
		});
	}
}
