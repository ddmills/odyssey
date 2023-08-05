package data.core;

import hxd.Pixels;

class ColorPaletteResources
{
	public static var palettes:Map<ColorPaletteKey, ColorPalette> = [];

	public static function Get(key:ColorPaletteKey):ColorPalette
	{
		if (key.isNull())
		{
			return null;
		}

		var palette = palettes.get(key);

		if (palette.isNull())
		{
			return palettes.get(ColorPaletteKey.PALETTE_ODYSSEY);
		}

		return palette;
	}

	public static function Init()
	{
		var odyssey = hxd.Res.tiles.palettes.odyssey.getPixels(BGRA);

		palettes.set(PALETTE_ODYSSEY, Parse(odyssey));
	}

	private static function Parse(img:Pixels):ColorPalette
	{
		var p = new ColorPalette();

		p.setColor(C_WHITE, img.getPixel(0, 0));
		p.setColor(C_GRAY_1, img.getPixel(1, 0));
		p.setColor(C_GRAY_2, img.getPixel(2, 0));
		p.setColor(C_GRAY_3, img.getPixel(3, 0));
		p.setColor(C_GRAY_4, img.getPixel(4, 0));
		p.setColor(C_GRAY_5, img.getPixel(5, 0));
		p.setColor(C_GRAY_6, img.getPixel(6, 0));
		p.setColor(C_BLACK, img.getPixel(7, 0));
		p.setColor(C_CLEAR, img.getPixel(7, 1));

		p.setColor(C_GREEN_0, img.getPixel(0, 1));
		p.setColor(C_GREEN_1, img.getPixel(1, 1));
		p.setColor(C_GREEN_2, img.getPixel(2, 1));
		p.setColor(C_GREEN_3, img.getPixel(3, 1));
		p.setColor(C_GREEN_4, img.getPixel(4, 1));
		p.setColor(C_GREEN_5, img.getPixel(5, 1));

		p.setColor(C_BLUE_0, img.getPixel(0, 2));
		p.setColor(C_BLUE_1, img.getPixel(1, 2));
		p.setColor(C_BLUE_2, img.getPixel(2, 2));
		p.setColor(C_BLUE_3, img.getPixel(3, 2));
		p.setColor(C_BLUE_4, img.getPixel(4, 2));
		p.setColor(C_BLUE_5, img.getPixel(5, 2));

		p.setColor(C_PURPLE_0, img.getPixel(0, 3));
		p.setColor(C_PURPLE_1, img.getPixel(1, 3));
		p.setColor(C_PURPLE_2, img.getPixel(2, 3));
		p.setColor(C_PURPLE_3, img.getPixel(3, 3));
		p.setColor(C_PURPLE_4, img.getPixel(4, 3));
		p.setColor(C_PURPLE_5, img.getPixel(5, 3));

		p.setColor(C_YELLOW_0, img.getPixel(0, 4));
		p.setColor(C_YELLOW_1, img.getPixel(1, 4));
		p.setColor(C_YELLOW_2, img.getPixel(2, 4));
		p.setColor(C_YELLOW_3, img.getPixel(3, 4));
		p.setColor(C_YELLOW_4, img.getPixel(4, 4));
		p.setColor(C_YELLOW_5, img.getPixel(5, 4));

		p.setColor(C_RED_0, img.getPixel(0, 5));
		p.setColor(C_RED_1, img.getPixel(1, 5));
		p.setColor(C_RED_2, img.getPixel(2, 5));
		p.setColor(C_RED_3, img.getPixel(3, 5));
		p.setColor(C_RED_4, img.getPixel(4, 5));
		p.setColor(C_RED_5, img.getPixel(5, 5));

		return p;
	}
}
