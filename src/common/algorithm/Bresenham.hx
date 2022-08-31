package common.algorithm;

import common.struct.IntPoint;

class Bresenham
{
	public static function getLine(a:IntPoint, b:IntPoint):Array<IntPoint>
	{
		var dx = (b.x - a.x).abs();
		var dy = (b.y - a.y).abs();
		var sx = a.x < b.x ? 1 : -1;
		var sy = a.y < b.y ? 1 : -1;
		var result = new Array<IntPoint>();
		var x = a.x;
		var y = a.y;

		var err = dx - dy;
		while (true)
		{
			result.push({
				x: x,
				y: y,
			});

			if (x == b.x && y == b.y)
			{
				break;
			}

			var e2 = 2 * err;

			if (e2 > -dy)
			{
				err -= dy;
				x += sx;
			}

			if (e2 < dx)
			{
				err += dx;
				y += sy;
			}
		}

		return result;
	}

	public static function getCircle(p:IntPoint, r:Int, fill:Bool = false):Array<IntPoint>
	{
		var pm = new Map<String, IntPoint>();
		var points = new Array<IntPoint>();
		var balance:Int = -r;
		var dx:Int = 0;
		var dy:Int = r;

		function addPoint(pt:IntPoint)
		{
			var k = '${pt.x},${pt.y}';
			if (pm.get(k) == null)
			{
				points.push(pt);
				pm.set(k, pt);
			}
		}

		while (dx <= dy)
		{
			if (fill)
			{
				var p0 = p.x - dx;
				var p1 = p.x - dy;
				var w0 = dx + dx + 1;
				var w1 = dy + dy + 1;

				hline(p0, p.y + dy, w0, function(p)
				{
					addPoint(p);
				});
				hline(p0, p.y - dy, w0, function(p)
				{
					addPoint(p);
				});
				hline(p1, p.y + dx, w1, function(p)
				{
					addPoint(p);
				});
				hline(p1, p.y - dx, w1, function(p)
				{
					addPoint(p);
				});
			}
			else
			{
				addPoint({x: p.x + dx, y: p.y + dy});
				addPoint({x: p.x - dx, y: p.y + dy});
				addPoint({x: p.x - dx, y: p.y - dy});
				addPoint({x: p.x + dx, y: p.y - dy});
				addPoint({x: p.x + dy, y: p.y + dx});
				addPoint({x: p.x - dy, y: p.y + dx});
				addPoint({x: p.x - dy, y: p.y - dx});
				addPoint({x: p.x + dy, y: p.y - dx});
			}

			dx++;
			balance += dx + dx;

			if (balance >= 0)
			{
				dy--;
				balance -= dy + dy;
			}
		}

		return points;
	}

	private static function hline(x:Int, y:Int, w:Int, fn:(IntPoint) -> Void)
	{
		for (i in 0...w)
		{
			fn({
				x: x + i,
				y: y
			});
		}
	}
}
