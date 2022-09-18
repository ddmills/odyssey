package ecs;

import bits.Bits;
import common.util.BitUtil;
import core.Game;

typedef QueryFilter =
{
	var ?all:Array<Class<Component>>;
	var ?any:Array<Class<Component>>;
	var ?none:Array<Class<Component>>;
}

class Query
{
	public var registry(get, null):Registry;
	public var size(default, null):Int;

	var any:Bits;
	var all:Bits;
	var none:Bits;
	var isDisposed:Bool;
	var cache:Map<String, Entity>;

	var onAddListeners:Array<(Entity) -> Void>;
	var onRemoveListeners:Array<(Entity) -> Void>;

	inline function get_registry():Registry
	{
		return Game.instance.registry;
	}

	public function new(filter:QueryFilter)
	{
		isDisposed = false;
		onAddListeners = new Array();
		onRemoveListeners = new Array();
		cache = new Map();
		size = 0;

		any = getBitmask(filter.any);
		all = getBitmask(filter.all);
		none = getBitmask(filter.none);

		registry.registerQuery(this);
		refresh();
	}

	public function matches(entity:Entity)
	{
		var flags = entity.flags;

		// todo: do better than counting
		var matchesAny = any.count() == 0 || flags.intersect(any).count() > 0;
		var matchesAll = flags.intersect(all).count() == all.count();
		var matchesNone = flags.intersect(none).count() == 0;

		return matchesAny && matchesAll && matchesNone;
	}

	public function candidate(entity:Entity)
	{
		var isTracking = cache.exists(entity.id);

		if (matches(entity))
		{
			if (!isTracking)
			{
				size++;
				cache.set(entity.id, entity);
				for (listener in onAddListeners)
				{
					listener(entity);
				}
			}

			return true;
		}

		if (isTracking)
		{
			size--;
			cache.remove(entity.id);
			for (listener in onRemoveListeners)
			{
				listener(entity);
			}
		}

		return false;
	}

	public function refresh()
	{
		size = 0;
		cache.clear();
		for (entity in registry)
		{
			candidate(entity);
		}
	}

	public inline function iterator():Iterator<Entity>
	{
		return new QueryIterator(this.cache);
	}

	public function onEntityAdded(fn:(Entity) -> Void)
	{
		onAddListeners.push(fn);
	}

	public function onEntityRemoved(fn:(Entity) -> Void)
	{
		onRemoveListeners.push(fn);
	}

	public function dispose()
	{
		isDisposed = true;
		onAddListeners = new Array();
		onRemoveListeners = new Array();
		cache = new Map();
		size = 0;
		registry.unregisterQuery(this);
	}

	function getBitmask(components:Array<Class<Component>>):Bits
	{
		var bits = new Bits();

		if (components == null)
		{
			return bits;
		}

		for (c in components)
		{
			bits.set(registry.getBit(c));
		}

		return bits;
	}
}

class QueryIterator
{
	var entities:Array<Entity> = [];
	var i:Int = 0;

	public inline function new(cache:Map<String, Entity>)
	{
		for (e in cache) // todo: fix double iteration
		{
			entities.push(e);
		}
	}

	public inline function hasNext()
	{
		if (i >= entities.length)
		{
			return false;
		}

		var next = entities[i];

		if (next.isDestroyed)
		{
			i++;
			return hasNext();
		}

		return true;
	}

	public inline function next():Entity
	{
		return entities[i++];
	}
}
