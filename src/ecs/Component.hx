package ecs;

import core.Game;
import haxe.rtti.Meta;

abstract class Component
{
	public var bit(get, null):Int = 0;
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

	private function addHandler<T:EntityEvent>(type:Class<T>, fn:(T) -> Void)
	{
		var className = Type.getClassName(type);
		handlers.set(className, cast fn);
	}

	function get_bit():Int
	{
		if (bit > 0)
		{
			return bit;
		}

		bit = Game.instance.registry.register(Type.getClass(this));

		return bit;
	}

	function onRemove() {}

	@:allow(ecs.Entity)
	private function onEvent(evt:EntityEvent)
	{
		var cls = Type.getClass(evt);
		var className = Type.getClassName(cls);
		var handler = handlers.get(className);
		if (handler != null && isAttached)
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
		var clazz = Type.getClass(this);
		var superClazz = Type.getSuperClass(clazz);
		var fields = Meta.getFields(clazz);
		var superFields = Meta.getFields(superClazz);
		var data = [];

		for (field in Reflect.fields(superFields))
		{
			var metas = Reflect.field(superFields, field);
			var tags = Reflect.fields(metas);
			if (tags.contains('save'))
			{
				var value = Reflect.getProperty(this, field);
				data.push({
					f: field,
					v: value,
				});
			}
		}

		for (field in Reflect.fields(fields))
		{
			var metas = Reflect.field(fields, field);
			var tags = Reflect.fields(metas);
			if (tags.contains('save'))
			{
				var value = Reflect.getProperty(this, field);
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
