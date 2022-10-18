package data.dialog.effects;

import core.Game;
import domain.components.FactionMember;
import screens.dialog.Conversation;

typedef DialogRelationEffectParams =
{
	isModifier:Bool,
	value:Int,
};

class DialogRelationEffect extends DialogEffect
{
	public var params:DialogRelationEffectParams;

	public function new(params:DialogRelationEffectParams)
	{
		this.params = params;
	}

	public function apply(conversation:Conversation)
	{
		var memberInteractor = conversation.interactor.get(FactionMember);
		var memberTarget = conversation.target.get(FactionMember);

		if (memberTarget == null || memberInteractor == null)
		{
			return;
		}

		if (params.isModifier)
		{
			memberTarget.setModifier(memberInteractor.factionType, params.value);
		}
		else
		{
			Game.instance.world.factions.changeRelation(memberInteractor.factionType, memberTarget.factionType, params.value);
		}
	}

	public static function FromJson(json:Dynamic):DialogRelationEffect
	{
		return new DialogRelationEffect({
			isModifier: json.isModifier,
			value: json.value,
		});
	}
}
