package ecs;

import common.struct.Set;

class Registry
{
	var cbit:Int;
	var bits:Map<String, Int>;
	var queries:Array<Query>;
	var entityMap:Map<String, Entity>;
	var detached:Set<String>;

	public var size(default, null):Int;

	public function new()
	{
		cbit = 0;
		size = 0;
		bits = new Map();
		entityMap = new Map();
		detached = new Set();
		queries = new Array();
	}

	public function register<T:Component>(type:Class<Component>):Int
	{
		var className = Type.getClassName(type);
		if (bits.exists(className))
		{
			return bits.get(className);
		}

		bits.set(className, ++cbit);

		return cbit;
	}

	public function getEntity(entityId:String)
	{
		return entityMap.get(entityId);
	}

	public function getBit<T:Component>(type:Class<Component>):Int
	{
		var className = Type.getClassName(type);

		var bit = bits.get(className);

		if (bit == null)
		{
			return register(type);
		}

		return bit;
	}

	public function candidacy(entity:Entity)
	{
		for (query in queries)
		{
			query.candidate(entity);
		}
	}

	public function getDetachedEntities():Iterator<String>
	{
		return detached.iterator();
	}

	@:allow(ecs.Query)
	function registerQuery(query:Query)
	{
		queries.push(query);
	}

	@:allow(ecs.Query)
	function unregisterQuery(query:Query)
	{
		queries.remove(query);
	}

	@:allow(ecs.Entity)
	function registerEntity(entity:Entity)
	{
		if (entityMap.exists(entity.id))
		{
			trace('Given entity id (${entity.id}) is already registered');
			return;
		}
		size++;
		entityMap.set(entity.id, entity);
	}

	@:allow(ecs.Entity)
	function unregisterEntity(entity:Entity)
	{
		candidacy(entity);
		size--;
		entityMap.remove(entity.id);
		detached.remove(entity.id);
	}

	@:allow(ecs.Entity)
	public function detachEntity(entityId:String)
	{
		detached.add(entityId);
	}

	@:allow(ecs.Entity)
	public function reattachEntity(entityId:String)
	{
		detached.remove(entityId);
	}

	public function iterator()
	{
		return entityMap.iterator();
	}
}
