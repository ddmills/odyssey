package data;

import common.struct.Grid;
import common.struct.IntPoint;
import data.BiomeType;
import hxd.Pixels;

typedef RiverData =
{
	n:Bool,
	ne:Bool,
	e:Bool,
	se:Bool,
	s:Bool,
	sw:Bool,
	w:Bool,
	nw:Bool,
};

typedef BiomeZoneData =
{
	nw:BiomeType,
	ne:BiomeType,
	se:BiomeType,
	sw:BiomeType,
	?river:RiverData,
};

class BiomeMap
{
	private static var landImg:Pixels;
	private static var waterImg:Pixels;
	private static var data:Grid<BiomeZoneData>;

	public static function Init()
	{
		landImg = hxd.Res.images.map.biomes_land.getPixels(BGRA);
		waterImg = hxd.Res.images.map.biomes_water.getPixels(BGRA);

		data = new Grid(landImg.width, landImg.height);
		data.fillFn((idx) ->
		{
			var pos = data.coord(idx);
			return Compute(pos);
		});
	}

	private static function ClampPos(pos:IntPoint):IntPoint
	{
		return {
			x: pos.x.clamp(0, landImg.width),
			y: pos.y.clamp(0, landImg.height),
		};
	}

	private static function GetBiome(pos:IntPoint):BiomeType
	{
		var clamped = ClampPos(pos);
		var px = landImg.getPixel(clamped.x, clamped.y);
		return ColorToBiome(px);
	}

	private static function GetRiver(pos:IntPoint):Bool
	{
		var clamped = ClampPos(pos);
		var px = waterImg.getPixel(clamped.x, clamped.y);
		return ColorToWater(px);
	}

	public static function Compute(pos:IntPoint):BiomeZoneData
	{
		var nw = GetBiome({x: pos.x, y: pos.y});
		var ne = GetBiome({x: pos.x + 1, y: pos.y});
		var se = GetBiome({x: pos.x + 1, y: pos.y + 1});
		var sw = GetBiome({x: pos.x, y: pos.y + 1});

		var isRiver = GetRiver(pos);
		var river:RiverData = null;

		if (isRiver)
		{
			var n = GetRiver({x: pos.x, y: pos.y - 1});
			var e = GetRiver({x: pos.x + 1, y: pos.y});
			var s = GetRiver({x: pos.x, y: pos.y + 1});
			var w = GetRiver({x: pos.x - 1, y: pos.y});
			var ne = n && e && GetRiver({x: pos.x + 1, y: pos.y - 1});
			var se = s && e && GetRiver({x: pos.x + 1, y: pos.y + 1});
			var sw = s && w && GetRiver({x: pos.x - 1, y: pos.y + 1});
			var nw = n && w && GetRiver({x: pos.x - 1, y: pos.y - 1});
			river = {
				n: n,
				ne: ne,
				e: e,
				se: se,
				s: s,
				sw: sw,
				w: w,
				nw: nw,
			};
		}

		return {
			nw: nw,
			ne: ne,
			se: se,
			sw: sw,
			river: river,
		};
	}

	public static function Get(pos:IntPoint):Null<BiomeZoneData>
	{
		return data.get(pos.x, pos.y);
	}

	public static function GetAt(idx:Int):Null<BiomeZoneData>
	{
		return data.getAt(idx);
	}

	public static function ColorToBiome(color:Int):BiomeType
	{
		var offset = (0xffffff + color) + 1;

		return switch offset
		{
			case 0x57723a: PRAIRIE;
			case 0x3c5837: FOREST;
			case 0xb3904d: DESERT;
			case 0x7a6681: SWAMP;
			case 0x5e8e97: TUNDRA;
			case _: MOUNTAIN;
		}
	}

	public static function ColorToWater(color:Int):Bool
	{
		var offset = (0xffffff + color) + 1;

		return offset == 0x326475;
	}
}
