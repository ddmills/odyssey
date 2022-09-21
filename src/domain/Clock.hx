package domain;

class Clock
{
	public static var DAY_START:Int = 0;
	public static var HOUR_START:Int = 10;

	public static var MINUTES_PER_HOUR:Int = 60;
	public static var HOURS_PER_DAY:Int = 24;

	public static var TICKS_PER_TURN:Int = 100;
	public static var TICKS_PER_MINUTE:Int = 100;
	public static var TICKS_PER_HOUR:Int = TICKS_PER_MINUTE * MINUTES_PER_HOUR;
	public static var TICKS_PER_DAY:Int = TICKS_PER_HOUR * HOURS_PER_DAY;

	public var tick(default, null):Int;
	public var tickDelta(default, null):Int;
	public var turnDelta(default, null):Int;
	public var turn(get, never):Int;
	public var subTurn(get, never):Int;

	public var day(get, never):Int;
	public var hour(get, never):Int;
	public var minute(get, never):Int;
	public var progress(get, never):Float;

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

	public static function ticksToMinutes(ticks:Int):Float
	{
		return ticks / TICKS_PER_MINUTE;
	}

	public static function ticksToHours(ticks:Int):Float
	{
		return ticks / TICKS_PER_HOUR;
	}

	public static function ticksToDays(ticks:Int):Float
	{
		return ticks / TICKS_PER_DAY;
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

	public function friendlyString()
	{
		var h = hour.toString().lpad(2);
		var m = minute.toString().lpad(2, '0');
		var d = day.floor();
		return '$d - $h:$m';
	}

	function get_day():Int
	{
		var days = ticksToDays(tick + (TICKS_PER_HOUR * HOUR_START));

		return days.floor();
	}

	function get_hour():Int
	{
		return (HOUR_START + ticksToHours(tick).floor()) % HOURS_PER_DAY;
	}

	function get_minute():Int
	{
		return ticksToMinutes(tick).floor() % MINUTES_PER_HOUR;
	}

	public function getDaylight():Float
	{
		var d = ticksToDays(tick + (TICKS_PER_HOUR * HOUR_START));
		var x = d - d.floor();
		return 1 - (Math.cos(2 * Math.PI * x) + 1) / 2;
	}

	function get_progress():Float
	{
		return (((HOUR_START) + ticksToHours(tick)) % HOURS_PER_DAY) / HOURS_PER_DAY;
	}
}
