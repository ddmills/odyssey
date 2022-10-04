package common.extensions;

import common.struct.IntPoint;
import data.Cardinal;

class CardinalExtensions
{
	public static function toName(cardinal:Cardinal):String
	{
		return switch cardinal
		{
			case NORTH: 'NORTH';
			case NORTH_EAST: 'NORTH_EAST';
			case EAST: 'EAST';
			case SOUTH_EAST: 'SOUTH_EAST';
			case SOUTH: 'SOUTH';
			case SOUTH_WEST: 'SOUTH_WEST';
			case WEST: 'WEST';
			case NORTH_WEST: 'NORTH_WEST';
		}
	}

	public static function toOffset(cardinal:Cardinal):IntPoint
	{
		return switch cardinal
		{
			case NORTH_WEST: {x: -1, y: -1};
			case NORTH: {x: 0, y: -1};
			case NORTH_EAST: {x: 1, y: -1};
			case WEST: {x: -1, y: 0};
			case EAST: {x: 1, y: 0};
			case SOUTH_WEST: {x: -1, y: 1};
			case SOUTH: {x: 0, y: 1};
			case SOUTH_EAST: {x: 1, y: 1};
		}
	}
}
