package domain.components;

import common.struct.Coordinate;
import core.rendering.RenderLayerManager.RenderLayerType;
import data.ColorKey;
import ecs.Component;
import shaders.SpriteShader;

abstract class Drawable extends Component
{
	@save public var primary(default, set):ColorKey;
	@save public var secondary(default, set):ColorKey;
	@save public var outline(default, set):ColorKey;
	@save public var background(default, set):Null<ColorKey>;
	@save public var enableLutShader(default, set):Bool = true;

	@save public var primaryOverride(default, set):Null<ColorKey> = null;
	@save public var secondaryOverride(default, set):Null<ColorKey> = null;
	@save public var outlineOverride(default, set):Null<ColorKey> = null;
	@save public var backgroundOverride(default, set):Null<ColorKey> = null;

	@save public var layer(default, null):RenderLayerType;
	@save public var isShrouded(default, set):Bool = false;
	@save public var isVisible(default, set):Bool = false;
	@save public var offsetX(default, set):Float = 0;
	@save public var offsetY(default, set):Float = 0;
	@save public var pos(default, set):Coordinate = null;

	public var primaryColor(get, never):ColorKey;
	public var secondaryColor(get, never):ColorKey;
	public var outlineColor(get, never):ColorKey;
	public var backgroundColor(get, never):Null<ColorKey>;

	public var shader(default, null):SpriteShader;
	public var drawable(get, never):h2d.Drawable;

	public function new(primary = C_WHITE, secondary = C_BLACK, layer = OBJECTS)
	{
		shader = new SpriteShader();

		this.layer = layer;
		this.primary = primary;
		this.secondary = secondary;
		this.outline = C_CLEAR;
	}

	abstract function getDrawable():h2d.Drawable;

	function set_primary(value:ColorKey):ColorKey
	{
		primary = value;
		shader.primary = value.toHxdColor().toVector();
		return value;
	}

	function set_secondary(value:ColorKey):ColorKey
	{
		secondary = value;
		shader.secondary = value.toHxdColor().toVector();
		return value;
	}

	function set_outline(value:ColorKey):ColorKey
	{
		outline = value;
		shader.outline = value.toHxdColor().toVector();
		return value;
	}

	function set_background(value:Null<ColorKey>):Null<ColorKey>
	{
		background = value;
		var clear = value != null;
		if (clear)
		{
			shader.background = value.toHxdColor().toVector();
		}
		shader.clearBackground = clear ? 1 : 0;
		return value;
	}

	public function getDrawnPosition()
	{
		if (pos != null)
		{
			return pos;
		}

		return new Coordinate(drawable.x, drawable.y, PIXEL);
	}

	public function updatePos(px:Float, py:Float)
	{
		if (pos != null)
		{
			var pix = pos.toPx();
			drawable.x = pix.x - offsetX;
			drawable.y = pix.y - offsetY;
		}
		else
		{
			drawable.x = px - offsetX;
			drawable.y = py - offsetY;
		}
	}

	function set_pos(value:Coordinate):Coordinate
	{
		if (value != null)
		{
			pos = value.toPx();
		}
		else
		{
			pos = null;
		}

		updatePos(drawable.x, drawable.y);
		return value;
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
		shader.setShrouded(value);
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

	function set_primaryOverride(value:Null<ColorKey>):Null<ColorKey>
	{
		primaryOverride = value;
		shader.primary = primaryColor.toHxdColor().toVector();
		return value;
	}

	function set_secondaryOverride(value:Null<ColorKey>):Null<ColorKey>
	{
		secondaryOverride = value;
		shader.secondary = secondaryColor.toHxdColor().toVector();
		return value;
	}

	function set_outlineOverride(value:Null<ColorKey>):Null<ColorKey>
	{
		outlineOverride = value;
		shader.outline = outlineColor.toHxdColor().toVector();
		return value;
	}

	function set_backgroundOverride(value:Null<ColorKey>):Null<ColorKey>
	{
		backgroundOverride = value;
		shader.background = backgroundColor.toHxdColor().toVector();
		return value;
	}

	function get_primaryColor():ColorKey
	{
		return primaryOverride == null ? primary : primaryOverride;
	}

	function get_secondaryColor():ColorKey
	{
		return secondaryOverride == null ? secondary : secondaryOverride;
	}

	function get_outlineColor():ColorKey
	{
		return outlineOverride == null ? outline : outlineOverride;
	}

	function get_backgroundColor():Null<ColorKey>
	{
		return backgroundOverride == null ? background : backgroundOverride;
	}

	inline function get_drawable():h2d.Drawable
	{
		return getDrawable();
	}

	function set_enableLutShader(value:Bool):Bool
	{
		enableLutShader = value;
		// shader.enableLut = value ? 1 : 0;
		return value;
	}
}
