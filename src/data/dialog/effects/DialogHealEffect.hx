package data.dialog.effects;

import domain.components.FactionMember;
import domain.events.HealEvent;
import screens.dialog.Conversation;

typedef DialogHealEffectParams = {};

class DialogHealEffect extends DialogEffect
{
	public var params:DialogHealEffectParams;

	public function new(params:DialogHealEffectParams)
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

		conversation.interactor.fireEvent(new HealEvent());
	}

	public static function FromJson(json:Dynamic):DialogHealEffect
	{
		return new DialogHealEffect({
			isModifier: json.isModifier,
			value: json.value,
		});
	}
}
