package data.dialog.conditions;

import screens.dialog.Conversation;

typedef DialogFlagConditionParams =
{
	flag:String,
	?invert:Bool,
}

class DialogFlagCondition extends DialogCondition
{
	public var params:DialogFlagConditionParams;

	public function new(params:DialogFlagConditionParams)
	{
		this.params = params;
	}

	public static function FromJson(json:Dynamic):DialogFlagCondition
	{
		return new DialogFlagCondition({
			flag: json.flag,
			invert: json.invert,
		});
	}

	public function check(conversation:Conversation):Bool
	{
		var c = conversation.target.get(domain.components.Dialog);

		var hasFlag = c.hasFlag(params.flag);

		if (params.invert.isNull())
		{
			return hasFlag;
		}

		return hasFlag != params.invert;
	}
}
