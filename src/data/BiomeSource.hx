package data;

import common.struct.Grid;
import common.struct.IntPoint;
import data.BiomeType;

typedef ZoneBiomeData =
{
	nw:BiomeType,
	ne:BiomeType,
	se:BiomeType,
	sw:BiomeType,
};

class BiomeSource
{
	public static var data:Grid<BiomeType>;

	public static function Init()
	{
		var img = hxd.Res.images.map.biomes_land.getPixels(BGRA);

		data = new Grid(img.width, img.height);
		data.fillFn((idx) ->
		{
			var pos = data.coord(idx);
			var px = img.getPixel(pos.x, pos.y);
			return ColorToBiome(px);
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

	public static function Get(p:IntPoint):Null<ZoneBiomeData>
	{
		var nw = data.get(p.x, p.y);
		var ne = data.get(p.x + 1, p.y);
		var se = data.get(p.x + 1, p.y + 1);
		var sw = data.get(p.x, p.y + 1);

		if (nw == null)
		{
			nw = se;
		}
		if (ne == null)
		{
			ne = se == null ? nw : se;
		}
		if (sw == null)
		{
			sw = se == null ? nw : se;
		}
		if (se == null)
		{
			se = sw == null ? ne : sw;
		}

		return {
			nw: nw,
			ne: ne,
			se: se,
			sw: sw,
		};
	}

	public static function GetAt(idx:Int):Null<ZoneBiomeData>
	{
		return Get(data.coord(idx));
	}
}
