package ecs;

import core.Game;

abstract class Component
{
	private var _bit:Int = 0;

	public var bit(get, null):Int;
	public var type(get, null):String;
	public var entity(default, null):Entity;
	public var isAttached(get, null):Bool;

	@:allow(core.ecs.Entity)
	public var instAllowMultiple(get, null):Bool;

	@:keep
	public static var allowMultiple(default, null):Bool;

	private var handlers:Map<String, (evt:EntityEvent) -> Void> = new Map();

	inline function get_type():String
	{
		return Type.getClassName(Type.getClass(this));
	}

	inline function get_entity():String
	{
		return Type.getClassName(Type.getClass(this));
	}

	private function addHandler<T:EntityEvent>(type:Class<T>, fn:(EntityEvent) -> Void)
	{
		var className = Type.getClassName(type);
		handlers.set(className, fn);
	}

	function get_bit():Int
	{
		if (_bit > 0)
		{
			return _bit;
		}

		_bit = Game.instance.registry.register(Type.getClass(this));

		return _bit;
	}

	function onRemove() {}

	@:allow(ecs.Entity)
	private function onEvent(evt:EntityEvent)
	{
		var cls = Type.getClass(evt);
		var className = Type.getClassName(cls);
		var handler = handlers.get(className);
		if (handler != null)
		{
			handler(evt);
		}
	}

	@:allow(ecs.Entity)
	function _attach(entity:Entity)
	{
		this.entity = entity;
	}

	@:allow(ecs.Entity)
	function _remove()
	{
		onRemove();
		entity = null;
	}

	inline function get_isAttached():Bool
	{
		return entity != null;
	}

	inline function get_instAllowMultiple():Bool
	{
		return Reflect.field(Type.getClass(this), 'allowMultiple'); // return allowMultiple;
	}
}
