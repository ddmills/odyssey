package common.algorithm;

import common.struct.IntPoint;

typedef ShadowcastSettings =
{
	var start:IntPoint;
	var decay:Float;
	var distance:Int;
	var isBlocker:(pos:IntPoint) -> Bool;
	var onLight:(pos:IntPoint, brightness:Float) -> Void;
};

class Shadowcast
{
	static var quadrants:Array<IntPoint> = [{x: -1, y: -1}, {x: 1, y: -1}, {x: -1, y: 1}, {x: 1, y: 1}];

	public static function Compute(settings:ShadowcastSettings)
	{
		settings.onLight(settings.start, 1);
		for (q in quadrants)
		{
			shadowcast(1, 1, 0, 0, q.x, q.y, 0, settings);
			shadowcast(1, 1, 0, q.x, 0, 0, q.y, settings);
		}
	}

	static function shadowcast(row:Int, start:Float, end:Float, xx:Int, xy:Int, yx:Int, yy:Int, s:ShadowcastSettings)
	{
		var newStart:Float = 0;

		if (start < end)
		{
			return;
		}

		var isBlocked:Bool = false;

		for (distance in row...(s.distance + 1))
		{
			if (isBlocked)
			{
				break;
			}

			var deltaY:Int = -distance;

			for (deltaX in (-distance...1))
			{
				var pos:IntPoint = {
					x: s.start.x + (deltaX * xx) + (deltaY * xy),
					y: s.start.y + (deltaX * yx) + (deltaY * yy),
				};
				var leftSlope:Float = (deltaX - 0.5) / (deltaY + 0.5);
				var rightSlope:Float = (deltaX + 0.5) / (deltaY - 0.5);

				if (rightSlope > start)
				{
					continue;
				}

				if (leftSlope < end)
				{
					break;
				}

				var deltaDistance = Math.sqrt(deltaX * deltaX + deltaY * deltaY).round();

				if (deltaDistance <= s.distance)
				{
					var brightness = 1 - (s.decay * deltaDistance);
					s.onLight(pos, brightness);
				}

				if (isBlocked)
				{
					if (s.isBlocker(pos))
					{
						newStart = rightSlope;
					}
					else
					{
						isBlocked = false;
						start = newStart;
					}
				}
				else
				{
					if (distance < s.distance && s.isBlocker(pos))
					{
						isBlocked = true;
						shadowcast(distance + 1, start, leftSlope, xx, xy, yx, yy, s);
						newStart = rightSlope;
					}
				}
			}
		}
	}
}
