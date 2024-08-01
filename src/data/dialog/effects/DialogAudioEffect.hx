package data.dialog.effects;

import core.Game;
import data.AudioKey;
import haxe.EnumTools;
import screens.dialog.Conversation;

typedef DialogAudioEffectParams =
{
	key:AudioKey,
};

class DialogAudioEffect extends DialogEffect
{
	public var params:DialogAudioEffectParams;

	public function new(params:DialogAudioEffectParams)
	{
		this.params = params;
	}

	public function apply(conversation:Conversation)
	{
		Game.instance.audio.play(params.key);
	}

	public static function FromJson(json:Dynamic):DialogAudioEffect
	{
		var key = EnumTools.createByName(AudioKey, json.key);

		return new DialogAudioEffect({
			key: key,
		});
	}
}
