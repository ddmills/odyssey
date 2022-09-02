package common.extensions;

import common.struct.IntPoint;
import data.Cardinal;

class CardinalExtensions
{
	public static function toOffset(cardinal:Cardinal):IntPoint
	{
		switch cardinal
		{
			case NORTH_WEST:
				return {
					x: -1,
					y: -1
				};
			case NORTH:
				return {
					x: 0,
					y: -1
				};
			case NORTH_EAST:
				return {
					x: 1,
					y: -1
				};
			case WEST:
				return {
					x: -1,
					y: 0
				};
			case EAST:
				return {
					x: 1,
					y: 0
				};
			case SOUTH_WEST:
				return {
					x: -1,
					y: 1
				};
			case SOUTH_EAST:
				return {
					x: 1,
					y: 1
				};
			case SOUTH:
				return {
					x: 0,
					y: 1
				};
		}
	}
}
