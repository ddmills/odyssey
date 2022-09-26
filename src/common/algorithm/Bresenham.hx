package common.algorithm;

import common.struct.IntPoint;

class Bresenham
{
	public static function getLine(a:IntPoint, b:IntPoint):Array<IntPoint>
	{
		var result = new Array<IntPoint>();
		stroke(a, b, (p) -> result.push(p));
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

	public static function stroke(a:IntPoint, b:IntPoint, fn:(IntPoint) -> Void)
	{
		var dx = (b.x - a.x).abs();
		var dy = (b.y - a.y).abs();
		var sx = a.x < b.x ? 1 : -1;
		var sy = a.y < b.y ? 1 : -1;
		var x = a.x;
		var y = a.y;

		var err = dx - dy;
		while (true)
		{
			fn({
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
	}

	public static function strokePolygon(polygon:Array<IntPoint>, fn:(IntPoint) -> Void)
	{
		for (i => p in polygon)
		{
			var nextI = i == polygon.length - 1 ? 0 : i + 1;
			var next = polygon[nextI];

			stroke(p, next, fn);
		}
	}

	public static function fillPolygon(polygon:Array<IntPoint>, fn:(IntPoint) -> Void)
	{
		var pair = getMinMaxPair(polygon);
		var min = pair[0];
		var max = pair[1];

		var yMin = min.y;
		var yMax = max.y + 1;

		for (y in yMin...yMax)
		{
			var intersections:Array<Int> = [];
			var nr = polygon.length;
			var j = nr - 1;

			for (i in 0...nr)
			{
				var a = polygon[i];
				var b = polygon[j];

				if (a.y == y && b.y == y)
				{
					intersections = [a.x, b.x];
					break;
				}
				if ((a.y < y && b.y >= y) || (b.y < y && a.y >= y))
				{
					var intersection = (a.x + ((y - a.y) / (b.y - a.y)) * (b.x - a.x)).round();
					intersections.push(intersection);
				}

				j = i;
			}

			intersections.sort((a, b) -> a - b);

			var i = 0;
			while (i < intersections.length)
			{
				var x1 = intersections[0];
				var x2 = intersections[1] + 1;

				for (x in x1...x2)
				{
					fn({
						x: x,
						y: y,
					});
				}

				i += 2;
			}
		}
	}

	private static function getMinMaxPair(polygon:Array<IntPoint>):Array<IntPoint>
	{
		var min:IntPoint = null;
		var max:IntPoint = null;

		for (p in polygon)
		{
			if (min == null)
			{
				min = p;
				max = p;
			}
			else
			{
				if (p.x < min.x)
				{
					min = {x: p.x, y: min.y};
				}
				else if (p.x > max.x)
				{
					max = {x: p.x, y: max.y};
				}

				if (p.y < min.y)
				{
					min = {x: min.x, y: p.y};
				}
				else if (p.y > max.y)
				{
					max = {x: max.x, y: p.y};
				}
			}
		}

		return [min, max];
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
