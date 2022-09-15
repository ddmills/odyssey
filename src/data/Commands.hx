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
		//  Domain                    Type                     Key            Shift   Ctrl   Alt
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_CONSOLE,             KEY_COMMA,     true);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_CYCLE_INPUT,         KEY_TAB);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_CYCLE_INPUT_REVERSE, KEY_TAB,       true);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_CONFIRM,             KEY_ENTER);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_CANCEL,              KEY_ESCAPE);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_NW,             KEY_NUMPAD_7);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_N,              KEY_UP);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_N,              KEY_NUMPAD_8);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_NE,             KEY_NUMPAD_9);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_W,              KEY_LEFT);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_W,              KEY_NUMPAD_4);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_E,              KEY_RIGHT);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_E,              KEY_NUMPAD_6);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_SW,             KEY_NUMPAD_1);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_S,              KEY_DOWN);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_S,              KEY_NUMPAD_2);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_MOVE_SE,             KEY_NUMPAD_3);
		cmd(INPUT_DOMAIN_DEFAULT,     CMD_WAIT,                KEY_NUMPAD_5);

		cmd(INPUT_DOMAIN_ADVENTURE,   CMD_LOOK,                KEY_L);
		cmd(INPUT_DOMAIN_ADVENTURE,   CMD_INTERACT,            KEY_SPACE);
		cmd(INPUT_DOMAIN_ADVENTURE,   CMD_EQUIPMENT,           KEY_E);
		cmd(INPUT_DOMAIN_ADVENTURE,   CMD_INVENTORY,           KEY_I);
		cmd(INPUT_DOMAIN_ADVENTURE,   CMD_CHARACTER,           KEY_C);
		cmd(INPUT_DOMAIN_ADVENTURE,   CMD_MAP,                 KEY_M);
		cmd(INPUT_DOMAIN_ADVENTURE,   CMD_SHOOT,               KEY_F);
		cmd(INPUT_DOMAIN_ADVENTURE,   CMD_RELOAD,              KEY_R);
		// @formatter:on
	}

	public static function GetForDomains(domains:Array<InputDomainType>):Array<Command>
	{
		return values.filter((c) -> domains.has(c.domain));
	}

	private static function cmd(domain:InputDomainType, type:CommandType, key:KeyCode, shift:Bool = false, ctrl:Bool = false, alt:Bool = false)
	{
		values.push({
			domain: domain,
			type: type,
			key: key,
			shift: shift,
			ctrl: ctrl,
			alt: alt,
		});
	}
}
