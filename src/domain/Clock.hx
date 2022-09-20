package domain;

class Clock
{
	public static var TICKS_PER_TURN:Int = 100;
	public static var TURNS_PER_HOUR:Int = 100;

	public static var TICKS_PER_HOUR:Int = TICKS_PER_TURN * TURNS_PER_HOUR;

	public var tick(default, null):Int;
	public var tickDelta(default, null):Int;
	public var turnDelta(default, null):Int;
	public var turn(get, never):Int;
	public var subTurn(get, never):Int;

	public function new()
	{
		tick = 0;
		tickDelta = 0;
		turnDelta = 0;
	}

	public function incrementTick(delta)
	{
		var prevTurn = turn;

		tickDelta += delta;
		tick += delta;

		turnDelta = turn - prevTurn;
	}

	public static function ticksToHours(ticks:Int):Float
	{
		return ticks / TICKS_PER_HOUR;
	}

	inline function get_turn():Int
	{
		return (tick / TICKS_PER_TURN).floor();
	}

	inline function get_subTurn():Int
	{
		return (tick % TICKS_PER_TURN).floor();
	}

	public function clearDeltas()
	{
		tickDelta = 0;
		turnDelta = 0;
	}

	public function toString()
	{
		return '${turn}.${subTurn}';
	}
}
