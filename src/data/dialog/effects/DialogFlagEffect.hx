package data.dialog.effects;

import screens.dialog.Conversation;

typedef DialogFlagEffectParams =
{
	flag:String,
	value:Bool,
};

class DialogFlagEffect extends DialogEffect
{
	public var params:DialogFlagEffectParams;

	public function new(params:DialogFlagEffectParams)
	{
		this.params = params;
	}

	public function apply(conversation:Conversation)
	{
		var c = conversation.target.get(domain.components.Dialog);

		c.setFlag(params.flag, params.value);
	}

	public static function FromJson(json:Dynamic):DialogFlagEffect
	{
		return new DialogFlagEffect({
			flag: json.flag,
			value: json.value,
		});
	}
}
