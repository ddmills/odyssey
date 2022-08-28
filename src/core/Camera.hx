package core;

import common.struct.Coordinate;
import common.util.Projection;
import data.KeyCode;
import data.Keybinding;
import h2d.Object;
import screens.console.ConsoleScreen;

class Camera
{
	public var mouse(default, null):Coordinate;
	public var width(get, null):Float;
	public var height(get, null):Float;
	public var zoom(get, set):Float;
	public var pos(get, set):Coordinate;
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var focus(get, set):Coordinate;

	public var scroller(get, null):h2d.Object;

	var scene:h2d.Scene;

	public function new()
	{
		mouse = new Coordinate(0, 0, SCREEN);
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
			mouse = new Coordinate(event.relX, event.relY, SCREEN);
		}

		if (event.kind == ERelease)
		{
			Game.instance.screens.current.onMouseUp(new Coordinate(event.relX, event.relY, SCREEN));
		}

		if (event.kind == EPush)
		{
			Game.instance.screens.current.onMouseDown(new Coordinate(event.relX, event.relY, SCREEN));
		}

		if (event.kind == EKeyUp)
		{
			var inConsole = Std.isOfType(Game.instance.screens.current, ConsoleScreen);

			var code:KeyCode = event.keyCode;

			if (!inConsole && Keybinding.CONSOLE_SCREEN == code)
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

	function get_scroller():Object
	{
		return Game.instance.layers.scroller;
	}

	function get_x():Float
	{
		var c = Projection.pxToWorld(-scroller.x / zoom, -scroller.y / zoom);

		return c.x;
	}

	function get_y():Float
	{
		var c = Projection.pxToWorld(-scroller.x / zoom, -scroller.y / zoom);

		return c.y;
	}

	function set_x(value:Float):Float
	{
		var p = Projection.worldToPx(value, y);

		scroller.x = -(p.x * zoom);
		scroller.y = -(p.y * zoom);

		return value;
	}

	function set_y(value:Float):Float
	{
		var p = Projection.worldToPx(x, value);

		scroller.x = -(p.x * zoom);
		scroller.y = -(p.y * zoom);

		return value;
	}

	function get_pos():Coordinate
	{
		return new Coordinate(x, y, WORLD);
	}

	function set_pos(value:Coordinate):Coordinate
	{
		var w = value.toWorld();
		x = w.x;
		y = w.y;
		return w;
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

	function set_focus(value:Coordinate):Coordinate
	{
		var mid = new Coordinate(width / 2, height / 2, SCREEN);

		pos = value.sub(mid).add(pos);

		return pos;
	}

	function get_focus():Coordinate
	{
		return new Coordinate(width / 2, height / 2, SCREEN);
	}
}
