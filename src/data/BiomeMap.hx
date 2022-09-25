package data;

import common.struct.Grid;
import common.struct.IntPoint;
import data.BiomeType;
import hxd.Pixels;

typedef BiomeChunkData =
{
	nw:BiomeType,
	ne:BiomeType,
	se:BiomeType,
	sw:BiomeType,
};

class BiomeMap
{
	private static var landImg:Pixels;
	private static var data:Grid<BiomeChunkData>;

	public static function Init()
	{
		landImg = hxd.Res.images.map.biomes_land.getPixels(BGRA);

		data = new Grid(landImg.width, landImg.height);
		data.fillFn((idx) ->
		{
			var pos = data.coord(idx);
			return Compute(pos);
		});
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

	public static function Compute(p:IntPoint):BiomeChunkData
	{
		var nw = GetBiome({x: p.x, y: p.y});
		var ne = GetBiome({x: p.x + 1, y: p.y});
		var se = GetBiome({x: p.x + 1, y: p.y + 1});
		var sw = GetBiome({x: p.x, y: p.y + 1});

		return {
			nw: nw,
			ne: ne,
			se: se,
			sw: sw,
		};
	}

	public static function Get(pos:IntPoint):Null<BiomeChunkData>
	{
		return data.get(pos.x, pos.y);
	}

	public static function GetAt(idx:Int):Null<BiomeChunkData>
	{
		return data.getAt(idx);
	}
}
