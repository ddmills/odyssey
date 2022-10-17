package data.dialog;

import screens.dialog.Conversation;

abstract class DialogCondition
{
	abstract public function check(conversation:Conversation):Bool;
}
