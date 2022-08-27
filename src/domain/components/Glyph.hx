package domain.components;

import ecs.Component;

@:structInit class Glyph extends Component
{
	private var _ch:String;

	public var ch(default, set):String;
	public var ob(default, null):h2d.Drawable;

	public function new(ch:String = '?')
	{
		_ch = ch;
	}

	// public var fg1(default, set):Int;
	// public var fg2(default, set):Int;
	// public var bg(default, set):Int;
	// public var z(default, set):Int;

	function set_ch(value:String):String
	{
		return _ch = value;
	}
}
