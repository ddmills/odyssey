package domain.components;

import core.rendering.RenderLayerManager.RenderLayerType;
import ecs.Component;
import h2d.Bitmap;
import h2d.Tile;
import shaders.SpriteShader;

@:structInit class Sprite extends Component
{
	private var _ch:String;
	private var _primary:Int;
	private var _secondary:Int;
	private var _outline:Int;
	private var _background:Int;
	private var _isShrouded:Bool;

	public var tile(default, null):Tile;
	public var layer(default, null):RenderLayerType;

	public var visible(get, set):Bool;
	public var primary(default, set):Int;
	public var secondary(default, set):Int;
	public var outline(default, set):Int;
	public var background(default, set):Null<Int>;
	public var isShrouded(default, set):Bool;
	public var offsetX(default, default):Float;
	public var offsetY(default, default):Float;

	public var ob(default, null):h2d.Drawable;
	public var shader(default, null):SpriteShader;

	public function new(tile:Tile, primary = 0xffffff, secondary = 0x000000, layer = OBJECTS)
	{
		this.tile = tile;
		_primary = primary;
		_secondary = secondary;
		this.layer = layer;

		shader = new SpriteShader(_primary, _secondary);

		ob = new Bitmap(tile);
		ob.addShader(shader);
		ob.visible = false;
	}

	function set_ch(value:String):String
	{
		return _ch = value;
	}

	function set_primary(value:Int):Int
	{
		shader.primary = value.toHxdColor();
		return _primary = value;
	}

	function set_secondary(value:Int):Int
	{
		shader.secondary = value.toHxdColor();
		return _secondary = value;
	}

	function set_outline(value:Int):Int
	{
		shader.outline = value.toHxdColor();
		return _outline = value;
	}

	function set_background(value:Null<Int>):Null<Int>
	{
		var clear = value != null;
		if (clear)
		{
			shader.background = value.toHxdColor();
		}
		shader.clearBackground = clear ? 1 : 0;
		return _background = value;
	}

	public function updatePos(px:Float, py:Float)
	{
		ob.x = px - offsetX;
		ob.y = py - offsetY;
	}

	inline function get_visible():Bool
	{
		return ob.visible;
	}

	inline function set_visible(value:Bool):Bool
	{
		return ob.visible = value;
	}

	override function onRemove()
	{
		ob.remove();
	}

	function set_isShrouded(value:Bool):Bool
	{
		shader.isShrouded = value ? 1 : 0;
		return _isShrouded = value;
	}
}
