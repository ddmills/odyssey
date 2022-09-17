package domain.components;

import core.Game;
import core.rendering.RenderLayerManager.RenderLayerType;
import ecs.Component;
import shaders.SpriteShader;

abstract class Drawable extends Component
{
	@save public var primary(default, set):Int;
	@save public var secondary(default, set):Int;
	@save public var outline(default, set):Int;
	@save public var background(default, set):Null<Int>;

	@save public var primaryOverride(default, set):Null<Int> = null;
	@save public var secondaryOverride(default, set):Null<Int> = null;
	@save public var outlineOverride(default, set):Null<Int> = null;
	@save public var backgroundOverride(default, set):Null<Int> = null;

	@save public var layer(default, null):RenderLayerType;
	@save public var isShrouded(default, set):Bool = false;
	@save public var isVisible(default, set):Bool = false;
	@save public var offsetX(default, set):Float = 0;
	@save public var offsetY(default, set):Float = 0;

	public var primaryColor(get, never):Int;
	public var secondaryColor(get, never):Int;
	public var outlineColor(get, never):Int;
	public var backgroundColor(get, never):Null<Int>;

	public var shader(default, null):SpriteShader;
	public var drawable(get, never):h2d.Drawable;

	public function new(primary = 0xffffff, secondary = 0x000000, layer = OBJECTS)
	{
		shader = new SpriteShader();

		this.layer = layer;
		this.primary = primary;
		this.secondary = secondary;
		this.outline = Game.instance.CLEAR_COLOR;
	}

	abstract function getDrawable():h2d.Drawable;

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
		drawable.x = px - offsetX;
		drawable.y = py - offsetY;
	}

	inline function set_isVisible(value:Bool):Bool
	{
		isVisible = value;
		return drawable.visible = value;
	}

	override function onRemove()
	{
		drawable.remove();
	}

	function set_isShrouded(value:Bool):Bool
	{
		isShrouded = value;
		shader.isShrouded = value ? 1 : 0;
		return value;
	}

	function set_offsetX(value:Float):Float
	{
		offsetX = value;
		drawable.x += offsetX;
		drawable.x -= value;
		return value;
	}

	function set_offsetY(value:Float):Float
	{
		offsetY = value;
		drawable.y += offsetY;
		drawable.y -= value;
		return value;
	}

	function set_primaryOverride(value:Null<Int>):Null<Int>
	{
		primaryOverride = value;
		shader.primary = primaryColor.toHxdColor();
		return value;
	}

	function set_secondaryOverride(value:Null<Int>):Null<Int>
	{
		secondaryOverride = value;
		shader.secondary = secondaryColor.toHxdColor();
		return value;
	}

	function set_outlineOverride(value:Null<Int>):Null<Int>
	{
		outlineOverride = value;
		shader.outline = outlineColor.toHxdColor();
		return value;
	}

	function set_backgroundOverride(value:Null<Int>):Null<Int>
	{
		backgroundOverride = value;
		shader.background = backgroundColor.toHxdColor();
		return value;
	}

	function get_primaryColor():Int
	{
		return primaryOverride == null ? primary : primaryOverride;
	}

	function get_secondaryColor():Int
	{
		return secondaryOverride == null ? secondary : secondaryOverride;
	}

	function get_outlineColor():Int
	{
		return outlineOverride == null ? outline : outlineOverride;
	}

	function get_backgroundColor():Null<Int>
	{
		return backgroundOverride == null ? background : backgroundOverride;
	}

	inline function get_drawable():h2d.Drawable
	{
		return getDrawable();
	}
}
