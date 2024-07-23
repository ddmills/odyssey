package domain.components;

import core.rendering.RenderLayerManager.RenderLayerType;
import data.ColorKey;
import data.TileKey;
import data.TileResources;
import h2d.Bitmap;
import h2d.Tile;
import shaders.SpriteShader;

class Sprite extends Drawable
{
	@save public var tileKey(default, set):TileKey;
	@save public var tileKeyOverride(default, set):TileKey;

	public var ob(default, null):Bitmap;
	public var tile(get, never):Tile;

	public function new(tileKey:TileKey, primary = C_WHITE, secondary = C_BLACK, layer = OBJECTS)
	{
		super(primary, secondary, layer);
		this.tileKey = tileKey;

		ob = new Bitmap(this.tile);
		ob.addShader(shader);
		ob.visible = false;
	}

	public function getBitmapClone():Bitmap
	{
		var bm = new Bitmap(tile);
		var sh = new SpriteShader(primaryColor, secondaryColor);
		sh.isShrouded = isShrouded ? 1 : 0;
		sh.enableLut = enableLutShader ? 1 : 0;
		if (backgroundColor == null)
		{
			sh.clearBackground = 0;
		}
		else
		{
			sh.clearBackground = 1;
			sh.background = backgroundColor.toHxdColor().toVector();
		}
		bm.addShader(sh);
		return bm;
	}

	function get_tile():Tile
	{
		if (tileKeyOverride != null)
		{
			return TileResources.Get(tileKeyOverride);
		}

		return TileResources.Get(tileKey);
	}

	public function set_tileKey(value:TileKey):TileKey
	{
		tileKey = value;
		if (ob != null)
		{
			ob.tile = tile;
		}
		return value;
	}

	function set_tileKeyOverride(value:TileKey):TileKey
	{
		tileKeyOverride = value;
		ob.tile = tile;

		return value;
	}

	function getDrawable():h2d.Drawable
	{
		return ob;
	}
}
