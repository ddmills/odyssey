package data;

import common.struct.DataRegistry;
import common.util.BitUtil;

enum BitmaskStyle
{
	BITMASK_STYLE_2D;
	BITMASK_STYLE_SIMPLE;
}

typedef BitmaskData =
{
	style:BitmaskStyle,
	tiles:Array<TileKey>,
};

class Bitmasks
{
	static var registry:DataRegistry<BitmaskType, BitmaskData>;

	public static function Init()
	{
		registry = new DataRegistry();

		registry.register(BITMASK_WALL, {
			style: BITMASK_STYLE_SIMPLE,
			tiles: [
				WALL_0, WALL_1, WALL_2, WALL_3, WALL_4, WALL_5, WALL_6, WALL_7, WALL_8, WALL_9, WALL_10, WALL_11, WALL_12, WALL_13, WALL_14, WALL_15
			],
		});
		registry.register(BITMASK_WINDOW, {
			style: BITMASK_STYLE_2D,
			tiles: [WALL_WINDOW_H, WALL_WINDOW_V],
		});
		registry.register(BITMASK_FENCE_IRON, {
			style: BITMASK_STYLE_SIMPLE,
			tiles: [
				FENCE_IRON_0, FENCE_IRON_1, FENCE_IRON_2, FENCE_IRON_3, FENCE_IRON_4, FENCE_IRON_5, FENCE_IRON_6, FENCE_IRON_7, FENCE_IRON_8, FENCE_IRON_9,
				FENCE_IRON_10, FENCE_IRON_11, FENCE_IRON_12, FENCE_IRON_13, FENCE_IRON_14, FENCE_IRON_15
			],
		});
		registry.register(BITMASK_FENCE_BARBED, {
			style: BITMASK_STYLE_SIMPLE,
			tiles: [
				FENCE_BARBED_0, FENCE_BARBED_1,  FENCE_BARBED_2,  FENCE_BARBED_3,  FENCE_BARBED_4,  FENCE_BARBED_5,  FENCE_BARBED_6, FENCE_BARBED_7,
				FENCE_BARBED_8, FENCE_BARBED_9, FENCE_BARBED_10, FENCE_BARBED_11, FENCE_BARBED_12, FENCE_BARBED_13, FENCE_BARBED_14, FENCE_BARBED_15
			],
		});
		registry.register(BITMASK_FENCE_BAR, {
			style: BITMASK_STYLE_SIMPLE,
			tiles: [
				FENCE_BARS_0, FENCE_BARS_1,  FENCE_BARS_2,  FENCE_BARS_3,  FENCE_BARS_4,  FENCE_BARS_5,  FENCE_BARS_6, FENCE_BARS_7,
				FENCE_BARS_8, FENCE_BARS_9, FENCE_BARS_10, FENCE_BARS_11, FENCE_BARS_12, FENCE_BARS_13, FENCE_BARS_14, FENCE_BARS_15
			],
		});
		registry.register(BITMASK_RAILROAD, {
			style: BITMASK_STYLE_SIMPLE,
			tiles: [
				RAILROAD_0, RAILROAD_1,  RAILROAD_2,  RAILROAD_3,  RAILROAD_4,  RAILROAD_5,  RAILROAD_6, RAILROAD_7,
				RAILROAD_8, RAILROAD_9, RAILROAD_10, RAILROAD_11, RAILROAD_12, RAILROAD_13, RAILROAD_14, RAILROAD_15
			],
		});
		registry.register(BITMASK_HIGHLIGHT, {
			style: BITMASK_STYLE_SIMPLE,
			tiles: [
				HIGHLIGHT_0, HIGHLIGHT_1,  HIGHLIGHT_2,  HIGHLIGHT_3,  HIGHLIGHT_4,  HIGHLIGHT_5,  HIGHLIGHT_6, HIGHLIGHT_7,
				HIGHLIGHT_8, HIGHLIGHT_9, HIGHLIGHT_10, HIGHLIGHT_11, HIGHLIGHT_12, HIGHLIGHT_13, HIGHLIGHT_14, HIGHLIGHT_15
			],
		});
		registry.register(BITMASK_HIGHLIGHT_DASH, {
			style: BITMASK_STYLE_SIMPLE,
			tiles: [
				HIGHLIGHT_DASH_0, HIGHLIGHT_DASH_1, HIGHLIGHT_DASH_2, HIGHLIGHT_DASH_3, HIGHLIGHT_DASH_4, HIGHLIGHT_DASH_5, HIGHLIGHT_DASH_6,
				HIGHLIGHT_DASH_7, HIGHLIGHT_DASH_8, HIGHLIGHT_DASH_9, HIGHLIGHT_DASH_10, HIGHLIGHT_DASH_11, HIGHLIGHT_DASH_12, HIGHLIGHT_DASH_13,
				HIGHLIGHT_DASH_14, HIGHLIGHT_DASH_15
			],
		});
	}

	public static function Get(bitmaskType:BitmaskType)
	{
		return registry.get(bitmaskType);
	}

	public static function SumMask(fn:(x:Int, y:Int) -> Bool):Int
	{
		var directions:Array<Cardinal> = [NORTH_WEST, NORTH, NORTH_EAST, WEST, EAST, SOUTH_WEST, SOUTH, SOUTH_EAST];
		return directions.foldi((direction, sum, idx) ->
		{
			var offset = direction.toOffset();
			var countCell = fn(offset.x, offset.y);

			return countCell ? sum + 2.pow(idx) : sum;
		}, 0);
	}

	public static function GetTileKey(bitmaskType:BitmaskType, mask:Int)
	{
		var bm = Get(bitmaskType);

		if (bm.style == BITMASK_STYLE_SIMPLE)
		{
			mask = BitUtil.subtractBit(mask, 0);
			mask = BitUtil.subtractBit(mask, 2);
			mask = BitUtil.subtractBit(mask, 5);
			mask = BitUtil.subtractBit(mask, 7);
			var idx = switch mask
			{
				case 66: 0;
				case 0: 1;
				case 80: 2;
				case 72: 3;
				case 2: 4;
				case 24: 5;
				case 18: 6;
				case 10: 7;
				case 88: 8;
				case 26: 9;
				case 90: 10;
				case 74: 11;
				case 82: 12;
				case 16: 13;
				case 8: 14;
				case 64: 15;
				case _: 1;
			};
			return bm.tiles[idx];
		}

		if (bm.style == BITMASK_STYLE_2D)
		{
			mask = BitUtil.subtractBit(mask, 0);
			mask = BitUtil.subtractBit(mask, 2);
			mask = BitUtil.subtractBit(mask, 5);
			mask = BitUtil.subtractBit(mask, 7);

			var idx = switch mask
			{
				case 66: 1;
				case 0: 0;
				case 2: 1;
				case 24: 0;
				case 16: 0;
				case 8: 0;
				case 64: 1;
				case _: 1;
			};
			return bm.tiles[idx];
		}

		return TK_UNKNOWN;
	}
}
