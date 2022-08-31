package data;

import core.input.Command;
import core.input.KeyCode;
import data.input.CommandType;
import data.input.InputDomainType;

class Commands
{
	public static var values:Array<Command>;

	public static function Init()
	{
		values = new Array();
		// @formatter:off
		//  Domain                    Type           Name                 Key            Shift   Ctrl   Alt
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_CONSOLE,   'open console',      KEY_COMMA,     true);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_CANCEL,    'cancel/back',       KEY_ESCAPE);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_NW,   'move north west',   KEY_NUMPAD_7);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_N,    'move north',        KEY_NUMPAD_8);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_NE,   'move north east',   KEY_NUMPAD_9);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_W,    'move west',         KEY_NUMPAD_4);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_E,    'move east',         KEY_NUMPAD_6);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_SW,   'move south west',   KEY_NUMPAD_1);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_S,    'move south',        KEY_NUMPAD_2);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_SE,   'move south east',   KEY_NUMPAD_3);
		cmd(INPUT_DOMAIN_ADVENTURE,   CMD_WAIT,      'wait',              KEY_NUMPAD_5);
		cmd(INPUT_DOMAIN_ADVENTURE,   CMD_LOOK,      'look',              KEY_L);
		// @formatter:on
	}

	public static function GetForDomains(domains:Array<InputDomainType>):Array<Command>
	{
		return values.filter((c) -> domains.has(c.domain));
	}

	private static function cmd(domain:InputDomainType, type:CommandType, name:String, key:KeyCode, shift:Bool = false, ctrl:Bool = false, alt:Bool = false)
	{
		values.push({
			domain: domain,
			type: type,
			name: name,
			key: key,
			shift: shift,
			ctrl: ctrl,
			alt: alt,
		});
	}
}
