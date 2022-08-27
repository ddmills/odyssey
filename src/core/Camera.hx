package core;

import common.struct.FloatPoint;
import data.Keybinding;
import h2d.Object;
import screens.console.ConsoleScreen;

class Camera
{
	public var mouse(default, null):FloatPoint;
	public var width(get, null):Float;
	public var height(get, null):Float;
	public var zoom(get, set):Float;
	public var x(get, set):Float;
	public var y(get, set):Float;

	var scroller(get, null):h2d.Object;

	var scene:h2d.Scene;

	public function new()
	{
		mouse = new FloatPoint(0, 0);
		onSceneChanged(Game.instance.app.s2d);
	}

	public function onSceneChanged(scene:h2d.Scene)
	{
		if (this.scene != null)
		{
			this.scene.removeEventListener(onSceneEvent);
		}

		this.scene = scene;
		scene.addEventListener(onSceneEvent);
	}

	function onSceneEvent(event:hxd.Event)
	{
		if (event.kind == EMove)
		{
			mouse = new FloatPoint(event.relX, event.relY);
		}

		if (event.kind == ERelease)
		{
			Game.instance.screens.current.onMouseUp(new FloatPoint(event.relX, event.relY));
		}

		if (event.kind == EPush)
		{
			Game.instance.screens.current.onMouseDown(new FloatPoint(event.relX, event.relY));
		}

		if (event.kind == EKeyUp)
		{
			var inConsole = Std.isOfType(Game.instance.screens.current, ConsoleScreen);

			if (!inConsole && Keybinding.CONSOLE_SCREEN.is(event.keyCode))
			{
				Game.instance.screens.push(new ConsoleScreen());
			}
			else
			{
				Game.instance.screens.current.onKeyUp(event.keyCode);
			}
		}
	}

	inline function get_width():Float
	{
		return hxd.Window.getInstance().width;
	}

	inline function get_height():Float
	{
		return hxd.Window.getInstance().height;
	}

	function get_x():Float
	{
		return scroller.x;
	}

	function set_x(value:Float):Float
	{
		return scroller.x = -value;
	}

	function get_scroller():Object
	{
		return Game.instance.layers.scroller;
	}

	function get_y():Float
	{
		return scroller.y;
	}

	function set_y(value:Float):Float
	{
		return scroller.y = -value;
	}

	function get_zoom():Float
	{
		return scroller.scaleX;
	}

	function set_zoom(value:Float):Float
	{
		scroller.setScale(value);

		return value;
	}
}
