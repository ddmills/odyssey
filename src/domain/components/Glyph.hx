package domain.components;

import ecs.Component;
import h2d.Tile;

@:structInit class Glyph extends Component
{
	private var _ch:String;

	public var ch(default, set):String;
	public var tile(default, null):Tile;

	public var fg1(default, null):Int;
	public var fg2(default, null):Int;

	// public var bg(default, set):Int;
	// public var z(default, set):Int;

	public function new(t:Tile, c1 = 0xffffff, c2 = 0x000000, ch:String = '?')
	{
		tile = t;
		fg1 = c1;
		fg2 = c2;
		_ch = ch;
	}

	function set_ch(value:String):String
	{
		return _ch = value;
	}
}
