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

		p.setColor(C_BRIGHT_WHITE, 0xffffff);
		p.setColor(C_WHITE, 0xcecba9);
		p.setColor(C_LIGHT_GRAY, 0xB1C0C5);
		p.setColor(C_GRAY, 0x5C7381);
		p.setColor(C_DARK_GRAY, 0x3B3B3B);
		p.setColor(C_BLACK, 0x1f1313);
		p.setColor(C_CLEAR, 0x1B222B);
		p.setColor(C_SHROUD, 0x272A2C);

		p.setColor(C_PURPLE, 0x913E96);
		p.setColor(C_DARK_GREEN, 0x2E3823);
		p.setColor(C_GREEN, 0x4E7214);

		p.setColor(C_DARK_RED, 0x642D2D);
		p.setColor(C_RED, 0xaa3b3b);
		p.setColor(C_ORANGE, 0xd67215);

		p.setColor(C_DARK_BLUE, 0x445E70);
		p.setColor(C_BLUE, 0x3E8DC5);

		p.setColor(C_YELLOW, 0xe0d948);
		p.setColor(C_BROWN, 0x81543B);
		p.setColor(C_DARK_BROWN, 0x583522);

		p.setColor(C_WOOD, p.getColor(C_RED));
		p.setColor(C_STONE, p.getColor(C_DARK_BLUE));

		p.setColor(C_TEXT_PRIMARY, 0xcecba9);

		return p;
	}
}
