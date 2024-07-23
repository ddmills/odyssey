package common.extensions.heaps;

import common.struct.FloatPoint;
import h2d.Object;

class ObjectExtensions
{
	public static function pos(o:Object):FloatPoint
	{
		return new FloatPoint(o.x, o.y);
	}
}
