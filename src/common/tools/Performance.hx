package common.tools;

import common.struct.Buffer;

typedef FrameSnapshot =
{
	var total:Float;
	var meters:Map<String, Float>;
}

class Performance
{
	public static var snapshots:Buffer<FrameSnapshot> = new Buffer<FrameSnapshot>();
	static var meters:Map<String, Meter> = new Map();

	static function getOrCreateMeter(name:String):Meter
	{
		var existing = meters.get(name);

		if (existing == null)
		{
			var meter = new Meter(name);

			meters.set(name, meter);

			return meter;
		}

		return existing;
	}

	public static function start(name:String):() -> String
	{
		var meter = getOrCreateMeter(name);
		meter.start();
		return () -> toString(name);
	}

	public static function stop(name:String, showTrace:Bool = false)
	{
		var meter = getOrCreateMeter(name);
		meter.stop();
		if (showTrace)
		{
			trace(toString(name));
		}
	}

	public static function get(name:String)
	{
		return getOrCreateMeter(name);
	}

	public static function trace(name:String)
	{
		trace(toString(name));
	}

	public static function toString(name:String)
	{
		var val = getOrCreateMeter(name).latest;
		var trunc = Math.floor(val * 100) / 100;

		return '${name} ${trunc}ms';
	}

	public static function percent(name:String)
	{
		var snapshot = snapshots.peek();
		return snapshot.meters.get(name);
	}

	public static function update(dt:Float)
	{
		var percentages = new Map<String, Float>();

		for (name => meter in meters)
		{
			percentages.set(name, meter.latest / dt);
		}

		snapshots.push({
			total: dt,
			meters: percentages
		});
	}
}
