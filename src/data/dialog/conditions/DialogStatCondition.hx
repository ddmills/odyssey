package data.dialog.conditions;

import data.StatType;
import domain.stats.Stats;
import haxe.EnumTools;
import screens.dialog.Conversation;

typedef DialogStatConditionParams =
{
	stat:StatType,
	?min:Int,
	?max:Int,
};

class DialogStatCondition extends DialogCondition
{
	public var params:DialogStatConditionParams;

	public function new(params:DialogStatConditionParams)
	{
		this.params = params;
	}

	public function check(conversation:Conversation):Bool
	{
		var stat = Stats.GetValue(params.stat, conversation.interactor);

		if (params.max != null && stat > params.max)
		{
			return false;
		}

		if (params.min != null && stat < params.min)
		{
			return false;
		}

		return true;
	}

	public static function FromJson(json:Dynamic):DialogStatCondition
	{
		var stat = EnumTools.createByName(StatType, json.stat);

		return new DialogStatCondition({
			stat: stat,
			min: json.min,
			max: json.max,
		});
	}
}
