package screens.elements;

import h2d.Font;
import h2d.Interactive;
import h2d.Object;
import h2d.Text;

typedef ButtonObs =
{
	?text:Text,
	?interactive:Interactive,
}

class Button extends Object
{
	private var obs:ButtonObs;

	public var font(default, set):Font;
	public var text(default, set):String;
	public var color(default, set):Int = 0x000000;
	public var focusColor(default, set):Int = 0x000000;
	public var isFocused(default, null):Bool;
	public var width(default, set):Int;
	public var height(default, set):Int;

	public function new(font:Font, ?parent:Object)
	{
		super(parent);

		obs = {};
		obs.text = new Text(font, this);
		obs.interactive = new Interactive(0, 0, this);
		obs.interactive.onClick = (e) -> onClick(e);
		obs.interactive.onOver = (_) -> focus();
		obs.interactive.onOut = (_) -> blur();
		obs.interactive.onFocus = (e) ->
		{
			isFocused = true;
			obs.text.color = focusColor.toHxdColor();
			onFocus(e);
		}
		obs.interactive.onFocusLost = (e) ->
		{
			isFocused = false;
			obs.text.color = color.toHxdColor();
			onFocusLost(e);
		}

		this.font = font;
		height = obs.text.textHeight.ciel();
	}

	public function focus()
	{
		obs.interactive.focus();
	}

	public function blur()
	{
		obs.interactive.blur();
	}

	public dynamic function onClick(e:hxd.Event) {}

	public dynamic function onFocus(e:hxd.Event) {}

	public dynamic function onFocusLost(e:hxd.Event) {}

	function set_text(value:String):String
	{
		return obs.text.text = value;
	}

	function set_color(value:Int):Int
	{
		color = value;
		obs.text.color = value.toHxdColor();
		return color;
	}

	function set_font(value:Font):Font
	{
		return obs.text.font = value;
	}

	function set_focusColor(value:Int):Int
	{
		focusColor = value;
		if (isFocused)
		{
			obs.text.color = focusColor.toHxdColor();
		}
		return focusColor;
	}

	function set_width(value:Int):Int
	{
		obs.interactive.width = value;
		width = value;
		return value;
	}

	function set_height(value:Int):Int
	{
		obs.interactive.height = value;
		height = value;
		return value;
	}
}
