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

		p.setColor(C_WHITE, 0xcecba9);
		p.setColor(C_LIGHT_GRAY, 0xB1C0C5);
		p.setColor(C_GRAY, 0x5B6D72);
		p.setColor(C_DARK_GRAY, 0x252525);
		p.setColor(C_BLACK, 0x1f1313);
		p.setColor(C_CLEAR, 0x0F151B);
		p.setColor(C_SHROUD, 0x242930);

		p.setColor(C_PURPLE, 0x763279);
		p.setColor(C_DARK_GREEN, 0x25381A);
		p.setColor(C_GREEN, 0x536D3D);

		p.setColor(C_DARK_RED, 0x502828);
		p.setColor(C_RED, 0xb15555);
		p.setColor(C_ORANGE, 0xd67215);

		p.setColor(C_DARK_BLUE, 0x28424D);
		p.setColor(C_BLUE, 0x427396);

		p.setColor(C_YELLOW, 0xd4ce4b);
		p.setColor(C_BROWN, 0x814C2F);
		p.setColor(C_DARK_BROWN, 0x442819);

		p.setColor(C_WOOD, p.getColor(C_BROWN));
		p.setColor(C_STONE, p.getColor(C_GRAY));

		p.setColor(C_TEXT_PRIMARY, 0xcecba9);

		return p;
	}
}
