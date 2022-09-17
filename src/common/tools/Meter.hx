package common.tools;

import common.struct.Buffer;

class Meter
{
	public var buffer(default, null):Buffer<Float>;
	public var name(default, null):String;
	public var latest(default, null):Float;
	public var isRunning(default, null):Bool;
	public var startTime(default, null):Float;

	public function new(name:String = 'unknown', bufferSize:Int = 30)
	{
		this.name = name;
		isRunning = false;
		buffer = new Buffer(bufferSize);
	}

	inline function now():Float
	{
		return haxe.Timer.stamp() * 1000.0;
	}

	public function start()
	{
		isRunning = true;
		startTime = now();
	}

	public function stop()
	{
		if (isRunning)
		{
			latest = now() - startTime;
			buffer.push(latest);
		}
	}

	public inline function iterator()
	{
		return buffer.iterator();
	}
}
