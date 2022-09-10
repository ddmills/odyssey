package ecs;

import core.Game;
import haxe.rtti.Meta;

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

	public function save():Array<ComponentFields>
	{
		var fields = Meta.getFields(Type.getClass(this));

		var data = [];
		for (field in Reflect.fields(fields))
		{
			var metas = Reflect.field(fields, field);
			var tags = Reflect.fields(metas);
			if (tags.contains('save'))
			{
				var value = Reflect.field(this, field);
				data.push({
					f: field,
					v: value,
				});
			}
		}

		return data;
	}

	public function load(data:Array<ComponentFields>)
	{
		for (field in data)
		{
			Reflect.setProperty(this, field.f, field.v);
		}
	}
}

typedef ComponentFields =
{
	f:String,
	v:Dynamic,
}
