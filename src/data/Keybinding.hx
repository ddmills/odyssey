package data;

import data.KeyCode;

enum abstract Keybinding(KeyCode) from KeyCode to KeyCode
{
	var BACK = KEY_ESCAPE;
	var CONSOLE_SCREEN = KEY_COMMA;
	var MOVE_NW = KEY_NUMPAD_7;
	var MOVE_N = KEY_NUMPAD_8;
	var MOVE_NE = KEY_NUMPAD_9;
	var MOVE_W = KEY_NUMPAD_4;
	var MOVE_WAIT = KEY_NUMPAD_5;
	var MOVE_E = KEY_NUMPAD_6;
	var MOVE_SW = KEY_NUMPAD_1;
	var MOVE_S = KEY_NUMPAD_2;
	var MOVE_SE = KEY_NUMPAD_3;
}
