package data.input;

enum abstract CommandType(String) to String
{
	var CMD_SAVE = 'save';
	var CMD_CONFIRM = 'confirm';
	var CMD_CYCLE_INPUT = 'tab input';
	var CMD_CYCLE_INPUT_REVERSE = 'tab input (reverse)';
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
	var CMD_EQUIPMENT = 'open equipment';
	var CMD_CHARACTER = 'open character';
	var CMD_SKILLS = 'open skills';
	var CMD_ABILITIES = 'open abilities';
	var CMD_MAP = 'open map';
	var CMD_LOOK = 'look';
	var CMD_INTERACT = 'interact';
	var CMD_SHOOT = 'shoot';
	var CMD_RELOAD = 'reload';
}
