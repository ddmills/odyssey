package data.dialog.conditions;

import core.Game;
import screens.dialog.Conversation;

typedef DialogRelationConditionParams =
{
	?min:Int,
	?max:Int,
}

class DialogRelationCondition extends DialogCondition
{
	public var params:DialogRelationConditionParams;

	public function new(params:DialogRelationConditionParams)
	{
		this.params = params;
	}

	public static function FromJson(json:Dynamic):DialogRelationCondition
	{
		return new DialogRelationCondition({
			min: json.min,
			max: json.max,
		});
	}

	public function check(conversation:Conversation):Bool
	{
		var relation = Game.instance.world.factions.getEntityRelation(conversation.interactor, conversation.target);

		if (params.max != null && relation > params.max)
		{
			return false;
		}

		if (params.min != null && relation < params.min)
		{
			return false;
		}

		return true;
	}
}
