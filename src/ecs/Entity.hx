package ecs;

import common.util.BitUtil;
import common.util.Serial;
import common.util.UniqueId;
import core.Game;

class Entity
{
	public var cbits(default, null):Int;

	public var game(get, null):Game;
	public var registry(get, null):Registry;
	public var id(default, null):String;

	private var components:Map<String, Component>;

	public function new()
	{
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
	}

	public function fireEvent(name:String):EntityEvent
	{
		var evt = new EntityEvent(name);

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
}
