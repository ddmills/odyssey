package core.input;

import data.input.CommandType;
import data.input.InputDomainType;
import haxe.EnumTools.EnumValueTools;
import haxe.EnumTools;

@:structInit class Command
{
	public var domain:InputDomainType;
	public var type:CommandType;
	public var name:String;
	public var key:KeyCode;
	public var shift:Bool;
	public var ctrl:Bool;
	public var alt:Bool;

	public function isMatch(event:KeyEvent):Bool
	{
		return key == event.key && shift == event.shift && ctrl == event.ctrl && alt == event.alt;
	}

	public function toString():String
	{
		return EnumValueTools.getName(type);
	}

	public function friendlyKey():String
	{
		var val = '';

		if (shift)
		{
			val += 'shift+';
		}
		if (ctrl)
		{
			val += 'ctrl+';
		}
		if (alt)
		{
			val += 'alt+';
		}

		val += key.toChar();

		return val;
	}
}
