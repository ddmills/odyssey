package domain.components;

import core.rendering.RenderLayerManager.RenderLayerType;
import ecs.Component;
import h2d.Tile;
import shaders.SpriteShader;

@:structInit class Glyph extends Component
{
	private var _ch:String;
	private var _primary:Int;
	private var _secondary:Int;

	public var ch(default, set):String;
	public var tile(default, null):Tile;

	public var primary(default, set):Int;
	public var secondary(default, set):Int;

	public var shader(default, null):SpriteShader;

	public var layer(default, null):RenderLayerType;

	public function new(tile:Tile, primary = 0xffffff, secondary = 0x000000, layer = OBJECTS)
	{
		this.tile = tile;
		_primary = primary;
		_secondary = secondary;
		this.layer = layer;

		shader = new SpriteShader(_primary, _secondary);

		_ch = ch;
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
}
