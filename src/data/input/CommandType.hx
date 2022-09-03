package data.input;

enum abstract CommandType(String) to String
{
	var CMD_CONFIRM = 'confirm';
	var CMD_CANCEL = 'cancel';
	var CMD_WAIT = 'wait';
	var CMD_MOVE_NW = 'move north west';
	var CMD_MOVE_N = 'move north';
	var CMD_MOVE_NE = 'move north east';
	var CMD_MOVE_W = 'move west';
	var CMD_MOVE_E = 'move east';
	var CMD_MOVE_SW = 'move south west';
	var CMD_MOVE_S = 'move south';
	var CMD_MOVE_SE = 'move south east';
	var CMD_CONSOLE = 'open console';
	var CMD_INVENTORY = 'open inventory';
	var CMD_LOOK = 'look';
	var CMD_INTERACT = 'interact';
}
