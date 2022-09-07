package ecs;

import common.struct.Coordinate;
import common.util.BitUtil;
import common.util.Serial;
import common.util.UniqueId;
import core.Game;
import domain.components.Sprite;
import domain.terrain.Chunk;

class Entity
{
	public var cbits(default, null):Int;

	public var sprite:Sprite;

	var _x:Float;
	var _y:Float;

	public var game(get, null):Game;
	public var registry(get, null):Registry;
	public var id(default, null):String;
	public var pos(get, set):Coordinate;
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var chunk(get, never):Chunk;

	private var components:Map<String, Array<Component>>;

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
			for (c in component)
			{
				remove(c);
			}
		}
		chunk.removeEntity(this);
		registry.unregisterEntity(this);
	}

	public function add(component:Component)
	{
		var type = Type.getClass(component);
		var clist = components.get(component.type);

		if (clist == null)
		{
			components.set(component.type, [component]);
		}
		else if (component.instAllowMultiple)
		{
			components.get(component.type).push(component);
		}
		else
		{
			if (has(type))
			{
				remove(type);
			}
		}

		cbits = BitUtil.addBit(cbits, component.bit);
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
		if (component.instAllowMultiple)
		{
			var clist = components.get(component.type);
			if (clist != null)
			{
				clist.remove(component);
				if (clist.length == 0)
				{
					cbits = BitUtil.subtractBit(cbits, component.bit);
					components.remove(component.type);
				}
			}
		}
		else
		{
			cbits = BitUtil.subtractBit(cbits, component.bit);
			components.remove(component.type);
		}

		component._remove();
		registry.candidacy(this);
		if (Std.isOfType(component, Sprite))
		{
			sprite = null;
		}
	}

	public function fireEvent<T:EntityEvent>(evt:T):T
	{
		components.each((a) -> a.each((c) -> c.onEvent(evt)));

		return evt;
	}

	public overload extern inline function remove(component:Component)
	{
		removeInstance(component);
	}

	public overload extern inline function remove<T:Component>(type:Class<T>)
	{
		if (Reflect.field(type, 'allowMultiple'))
		{
			var cs = getAll(type);
			cs.each(removeInstance);
		}
		else
		{
			var c = get(type);
			if (c != null)
			{
				removeInstance(c);
			}
		}
	}

	public function getAll<T:Component>(type:Class<T>):Array<T>
	{
		var className = Type.getClassName(type);
		var cs = components.get(className);

		return cs == null ? [] : cast cs;
	}

	public function get<T:Component>(type:Class<T>):T
	{
		var className = Type.getClassName(type);
		var component = components.get(className);

		if (component == null)
		{
			return null;
		}

		return cast component[0];
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

	function get_chunk():Chunk
	{
		return Game.instance.world.chunks.getChunkById(pos.toChunkIdx());
	}
}
