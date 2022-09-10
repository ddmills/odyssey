package domain.components;

import core.Game;
import core.rendering.RenderLayerManager.RenderLayerType;
import data.TileKey;
import data.TileResources;
import ecs.Component;
import h2d.Bitmap;
import h2d.Tile;
import shaders.SpriteShader;

class Sprite extends Component
{
	@save public var tileKey(default, set):TileKey;
	@save public var overrideTileKey(default, set):TileKey;

	@save public var primary(default, set):Int;
	@save public var secondary(default, set):Int;
	@save public var outline(default, set):Int;
	@save public var background(default, set):Null<Int>;

	@save public var layer(default, null):RenderLayerType;
	@save public var isShrouded(default, set):Bool = false;
	@save public var isVisible(default, set):Bool = false;
	@save public var offsetX(default, set):Float = 0;
	@save public var offsetY(default, set):Float = 0;

	public var ob(default, null):Bitmap;
	public var tile(get, never):Tile;
	public var shader(default, null):SpriteShader;

	public function new(tileKey:TileKey, primary = 0xffffff, secondary = 0x000000, layer = OBJECTS)
	{
		shader = new SpriteShader();

		this.tileKey = tileKey;
		this.layer = layer;
		this.primary = primary;
		this.secondary = secondary;
		this.outline = Game.instance.CLEAR_COLOR;

		ob = new Bitmap(this.tile);
		ob.addShader(shader);
		ob.visible = false;
	}

	public function getBitmapClone():Bitmap
	{
		var bm = new Bitmap(tile);
		var sh = new SpriteShader(primary, secondary);
		sh.isShrouded = isShrouded ? 1 : 0;
		if (background == null)
		{
			sh.clearBackground = 0;
		}
		else
		{
			sh.clearBackground = 1;
			sh.background = background.toHxdColor();
		}
		bm.addShader(sh);
		return bm;
	}

	function set_primary(value:Int):Int
	{
		primary = value;
		shader.primary = value.toHxdColor();
		return value;
	}

	function set_secondary(value:Int):Int
	{
		secondary = value;
		shader.secondary = value.toHxdColor();
		return value;
	}

	function set_outline(value:Int):Int
	{
		outline = value;
		shader.outline = value.toHxdColor();
		return value;
	}

	function set_background(value:Null<Int>):Null<Int>
	{
		background = value;
		var clear = value != null;
		if (clear)
		{
			shader.background = value.toHxdColor();
		}
		shader.clearBackground = clear ? 1 : 0;
		return value;
	}

	public function updatePos(px:Float, py:Float)
	{
		ob.x = px - offsetX;
		ob.y = py - offsetY;
	}

	inline function set_isVisible(value:Bool):Bool
	{
		isVisible = value;
		return ob.visible = value;
	}

	override function onRemove()
	{
		ob.remove();
	}

	function set_isShrouded(value:Bool):Bool
	{
		isShrouded = true;
		shader.isShrouded = value ? 1 : 0;
		return value;
	}

	function get_tile():Tile
	{
		if (overrideTileKey != null)
		{
			return TileResources.Get(overrideTileKey);
		}

		return TileResources.Get(tileKey);
	}

	function set_offsetX(value:Float):Float
	{
		offsetX = value;
		ob.x += offsetX;
		ob.x -= value;
		return value;
	}

	function set_offsetY(value:Float):Float
	{
		offsetY = value;
		ob.y += offsetY;
		ob.y -= value;
		return value;
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

	function set_overrideTileKey(value:TileKey):TileKey
	{
		overrideTileKey = value;
		ob.tile = tile;

		return value;
	}
}
