package data.dialog;

import screens.dialog.Conversation;

abstract class DialogEffect
{
	abstract public function apply(conversation:Conversation):Void;
}
