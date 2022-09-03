package ecs;

import common.struct.Coordinate;
import common.util.BitUtil;
import common.util.Serial;
import common.util.UniqueId;
import core.Game;
import domain.components.Sprite;

class Entity
{
	public var cbits(default, null):Int;

	var sprite:Sprite;
	var _x:Float;
	var _y:Float;

	public var game(get, null):Game;
	public var registry(get, null):Registry;
	public var id(default, null):String;
	public var pos(get, set):Coordinate;
	public var x(get, set):Float;
	public var y(get, set):Float;

	private var components:Map<String, Component>;

	public function new()
	{
		_x = 0;
		_y = 0;
		cbits = 0;
		components = new Map();
		genId();
	}

	@:allow(ecs.Entity)
	function genId()
	{
		id = UniqueId.Create();
		registry.registerEntity(this);
	}

	inline function get_game():Game
	{
		return Game.instance;
	}

	public function destroy()
	{
		for (component in components)
		{
			remove(component);
		}
		registry.unregisterEntity(this);
	}

	public function add(component:Component)
	{
		var type = Type.getClass(component);
		if (has(type))
		{
			remove(type);
			// throw 'Entity already has instance of component';
		}

		cbits = BitUtil.addBit(cbits, component.bit);
		components.set(component.type, component);
		component._attach(this);
		registry.candidacy(this);
		if (Std.isOfType(component, Sprite))
		{
			sprite = cast component;
			var p = pos.toPx();
			sprite.updatePos(p.x, p.y);
		}
	}

	public function has<T:Component>(type:Class<Component>):Bool
	{
		return BitUtil.hasBit(cbits, registry.getBit(type));
	}

	function removeInstance(component:Component)
	{
		cbits = BitUtil.subtractBit(cbits, component.bit);
		components.remove(component.type);
		component._remove();
		registry.candidacy(this);
		if (Std.isOfType(component, Sprite))
		{
			sprite = null;
		}
	}

	public function fireEvent(evt:EntityEvent):EntityEvent
	{
		components.each((c) -> c.onEvent(evt));

		return evt;
	}

	public overload extern inline function remove(component:Component)
	{
		removeInstance(component);
	}

	public overload extern inline function remove<T:Component>(type:Class<T>)
	{
		var c = get(type);
		if (c != null)
		{
			removeInstance(c);
		}
	}

	public function get<T:Component>(type:Class<T>):T
	{
		var className = Type.getClassName(type);
		var component = components.get(className);

		if (component == null)
		{
			return null;
		}

		return cast component;
	}

	inline function get_registry():Registry
	{
		return Game.instance.registry;
	}

	public function clone():Entity
	{
		var output = Serial.Serialize(this);
		var clone:Entity = Serial.Deserialize(output);
		clone.genId();

		return clone;
	}

	function get_pos():Coordinate
	{
		return new Coordinate(_x, _y, WORLD);
	}

	function set_pos(value:Coordinate):Coordinate
	{
		var prevChunkIdx = pos.toChunkIdx();

		var p = value.toPx();
		var w = value.toWorld();

		if (sprite != null)
		{
			sprite.updatePos(p.x, p.y);
		}

		_x = w.x;
		_y = w.y;

		var nextChunkIdx = pos.toChunkIdx();

		if (prevChunkIdx != nextChunkIdx)
		{
			var prevChunk = Game.instance.world.chunks.getChunkById(prevChunkIdx);
			if (prevChunk != null)
			{
				prevChunk.removeEntity(this);
			}
		}
		var nextChunk = Game.instance.world.chunks.getChunkById(nextChunkIdx);
		if (nextChunk != null)
		{
			nextChunk.setEntityPosition(this);
		}
		return w;
	}

	function get_x():Float
	{
		return _x;
	}

	function get_y():Float
	{
		return _y;
	}

	function set_x(value:Float):Float
	{
		set_pos(new Coordinate(value, _y, WORLD));
		return _x;
	}

	function set_y(value:Float):Float
	{
		set_pos(new Coordinate(_x, value, WORLD));
		return _y;
	}
}
