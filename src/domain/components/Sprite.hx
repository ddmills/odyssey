package domain.components;

import core.Game;
import ecs.Component;

class Sprite extends Component
{
	public var ob(default, null):h2d.Drawable;
	public var offsetX(default, default):Float;
	public var offsetY(default, default):Float;
	public var visible(get, set):Bool;

	public function new(ob:h2d.Drawable, offsetX = 0, offsetY = 0)
	{
		this.ob = ob;
		this.ob.visible = true;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}

	public function updatePos(px:Float, py:Float)
	{
		ob.x = Game.instance.TILE_W * (px - offsetX);
		ob.y = Game.instance.TILE_H * (py - offsetY);
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
}
