package data;

import common.struct.DataRegistry;
import common.util.BitUtil;

enum BitmaskStyle
{
	BITMASK_STYLE_2D;
	BITMASK_STYLE_SIMPLE;
	BITMASK_STYLE_FULL;
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
		registry.register(BITMASK_WALL_THICK, {
			style: BITMASK_STYLE_FULL,
			tiles: [
				WALL_THICK_0_0, WALL_THICK_0_1,  WALL_THICK_0_2,  WALL_THICK_0_3, WALL_THICK_0_4, WALL_THICK_0_5,  WALL_THICK_0_6,  WALL_THICK_0_7,
				WALL_THICK_0_8, WALL_THICK_0_9, WALL_THICK_0_10, WALL_THICK_0_11, WALL_THICK_1_0, WALL_THICK_1_1,  WALL_THICK_1_2,  WALL_THICK_1_3,
				WALL_THICK_1_4, WALL_THICK_1_5,  WALL_THICK_1_6,  WALL_THICK_1_7, WALL_THICK_1_8, WALL_THICK_1_9, WALL_THICK_1_10, WALL_THICK_1_11,
				WALL_THICK_2_0, WALL_THICK_2_1,  WALL_THICK_2_2,  WALL_THICK_2_3, WALL_THICK_2_4, WALL_THICK_2_5,  WALL_THICK_2_6,  WALL_THICK_2_7,
				WALL_THICK_2_8, WALL_THICK_2_9, WALL_THICK_2_10, WALL_THICK_2_11, WALL_THICK_3_0, WALL_THICK_3_1,  WALL_THICK_3_2,  WALL_THICK_3_3,
				WALL_THICK_3_4, WALL_THICK_3_5,  WALL_THICK_3_6,  WALL_THICK_3_7, WALL_THICK_3_8, WALL_THICK_3_9, WALL_THICK_3_10, WALL_THICK_3_11
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

	public static function GetTileIndex(style:BitmaskStyle, mask:Int)
	{
		if (style == BITMASK_STYLE_FULL)
		{
			return switch mask
			{
				// thin strait
				case 66, 67, 70, 71, 98, 102, 103, 194, 231, 195, 226, 230, 198, 199, 99, 227: 12; // |
				case 24, 25, 28, 29, 57, 60, 61, 184, 152, 153, 56, 156, 157, 189, 185, 188: 38; // -

				// thin endcap
				case 64, 65, 69, 68, 224, 225, 228, 96, 97, 192, 193, 196, 197, 229, 100, 101: 0;
				case 2, 3, 6, 7, 34, 35, 38, 39, 166, 167, 130, 131, 134, 135, 162, 163: 24;
				case 16, 17, 21, 48, 49, 53, 148, 149, 20, 144, 145, 52, 180, 176, 181: 37;
				case 8, 40, 41, 44, 45, 9, 136, 137, 12, 168, 169, 140, 141, 13, 172, 173: 39;

				// thin corners
				case 80, 81, 84, 85, 112, 113, 116, 117: 1;
				case 72, 73, 76, 77, 200, 201, 204, 205: 3;
				case 18, 19, 50, 51, 146, 147, 178, 179: 25;
				case 10, 14, 42, 46, 170, 174, 138, 142: 27;

				// thin T joint
				case 88, 89, 92, 93: 2;
				case 26, 154, 186, 58: 26;
				case 82, 83, 114, 115: 13;
				case 74, 202, 206, 78: 15;

				// thick to thin T joints
				case 210, 242, 211, 243: 16;
				case 106, 110, 234, 238: 19;
				case 75, 79, 203, 207: 31;
				case 86, 87, 118, 119: 28;

				case 216, 217, 220, 221: 5;
				case 120, 121, 124, 125: 6;
				case 27, 59, 155, 187: 42;
				case 30, 158, 62, 190: 41;

				// thick/thin corners
				case 218: 43;
				case 122: 40;
				case 91: 4;
				case 94: 7;

				case 219: 34;
				case 126: 21;

				// thick exterior corners
				case 208, 240, 212, 213, 241, 245, 244, 209: 8;
				case 104, 232, 105, 109, 236, 237, 233, 108: 11;
				case 11, 15, 43, 143, 171, 175, 47, 139: 47;
				case 22, 23, 150, 182, 55, 183, 151, 54: 44;

				// thick interior corners
				case 254: 17;
				case 251: 18;
				case 127: 30;
				case 223: 29;

				// thick strait
				case 248, 249, 252, 253: 10;
				case 107, 111, 235, 239: 35;
				case 31, 159, 63, 191: 45;
				case 214, 246, 215, 247: 20;

				// thick T joint
				case 250: 9;
				case 123: 23;
				case 95: 46;
				case 222: 32;

				// filled
				case 255: 33;

				// thin cross joint
				case 90: 14;

				// single post
				case _: 36;
			}
		}

		if (style == BITMASK_STYLE_SIMPLE)
		{
			mask = BitUtil.subtractBit(mask, 0);
			mask = BitUtil.subtractBit(mask, 2);
			mask = BitUtil.subtractBit(mask, 5);
			mask = BitUtil.subtractBit(mask, 7);
			return switch mask
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
		}

		if (style == BITMASK_STYLE_2D)
		{
			mask = BitUtil.subtractBit(mask, 0);
			mask = BitUtil.subtractBit(mask, 2);
			mask = BitUtil.subtractBit(mask, 5);
			mask = BitUtil.subtractBit(mask, 7);

			return switch mask
			{
				case 66: 1;
				case 0: 0;
				case 2: 1;
				case 24: 0;
				case 16: 0;
				case 8: 0;
				case 64: 1;
				case _: 1;
			}
		}

		return -1;
	}

	public static function GetTileKey(bitmaskType:BitmaskType, mask:Int)
	{
		var bm = Get(bitmaskType);
		var idx = GetTileIndex(bm.style, mask);

		if (idx >= 0 && idx < bm.tiles.length)
		{
			return bm.tiles[idx];
		}

		return TK_UNKNOWN;
	}
}
