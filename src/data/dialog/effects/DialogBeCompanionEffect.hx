package data.dialog.effects;

import core.Game;
import domain.ai.behaviours.Behaviour;
import domain.components.Actor;
import domain.components.FactionMember;
import screens.dialog.Conversation;

typedef DialogBeCompanionEffectParams = {};

class DialogBeCompanionEffect extends DialogEffect
{
	public var params:DialogBeCompanionEffectParams;

	public function new(params:DialogBeCompanionEffectParams)
	{
		this.params = params;
	}

	public function apply(conversation:Conversation)
	{
		// set faction
		var memberInteractor = conversation.interactor.get(FactionMember);

		if (memberInteractor == null)
		{
			return;
		}

		conversation.target.remove(FactionMember);
		conversation.target.add(new FactionMember(memberInteractor.factionType));

		// set Behavior
		conversation.target.remove(Actor);
		var actor = new Actor(BHV_BASIC_COMPANION);
		actor.leaderEntityId = conversation.interactor.id;
		conversation.target.add(actor);
	}

	public static function FromJson(json:Dynamic):DialogBeCompanionEffect
	{
		return new DialogBeCompanionEffect({
			isModifier: json.isModifier,
			value: json.value,
		});
	}
}
