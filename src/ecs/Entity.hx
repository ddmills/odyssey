package ecs;

import bits.Bits;
import common.struct.Coordinate;
import common.util.UniqueId;
import core.Game;
import domain.components.Drawable;
import domain.components.IsDetached;
import domain.events.EntityLoadedEvent;
import domain.events.MovedEvent;
import domain.terrain.Chunk;

class Entity
{
	public var flags(default, null):Bits;

	public var drawable:Drawable;

	var _x:Float;
	var _y:Float;

	public var game(get, null):Game;
	public var registry(get, null):Registry;
	public var id(default, null):String;
	public var pos(get, set):Coordinate;
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var chunk(get, never):Chunk;
	public var chunkIdx(get, never):Int;
	public var isDestroyed(default, null):Bool;
	public var isDetached(default, null):Bool;
	public var isDetachable:Bool;

	private var components:Map<String, Array<Component>>;

	private var isCandidacyEnabled = true;

	public function new(register = true)
	{
		_x = 0;
		_y = 0;
		flags = new Bits(64);
		components = new Map();
		isDestroyed = false;
		isDetached = false;
		isDetachable = false;
		if (register)
		{
			setId(UniqueId.Create());
		}
	}

	public function setId(value:String)
	{
		id = value;
		registry.registerEntity(this);
	}

	inline function get_game():Game
	{
		return Game.instance;
	}

	public function destroy()
	{
		isCandidacyEnabled = false;
		for (component in components.copy())
		{
			for (c in component.copy())
			{
				remove(c);
			}
		}
		isCandidacyEnabled = true;
		isDestroyed = true;
		if (chunk != null) // TODO never null
		{
			chunk.removeEntity(this);
		}
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
			components.set(component.type, [component]);
		}

		flags.set(component.bit);
		component._attach(this);
		if (isCandidacyEnabled)
		{
			registry.candidacy(this);
		}
		if (Std.isOfType(component, Drawable))
		{
			drawable = cast component;
			var p = pos.toPx();
			drawable.updatePos(p.x, p.y);
		}
	}

	public inline function has<T:Component>(type:Class<Component>):Bool
	{
		return flags.isSet(registry.getBit(type));
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
					flags.unset(component.bit);
					components.remove(component.type);
				}
			}
		}
		else
		{
			flags.unset(component.bit);
			components.remove(component.type);
		}

		component._remove();
		if (isCandidacyEnabled)
		{
			registry.candidacy(this);
		}
		if (Std.isOfType(component, Drawable))
		{
			drawable = null;
		}
	}

	public function fireEvent<T:EntityEvent>(evt:T):T
	{
		components.each((a) ->
		{
			a.each((c) ->
			{
				c.onEvent(evt);
			});
		});

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

	function get_pos():Coordinate
	{
		return new Coordinate(_x, _y, WORLD);
	}

	function set_pos(value:Coordinate):Coordinate
	{
		var prevChunkIdx = chunkIdx;

		var p = value.toPx();
		var w = value.toWorld();

		if (drawable != null)
		{
			drawable.updatePos(p.x, p.y);
		}

		_x = w.x;
		_y = w.y;

		var nextChunkIdx = chunkIdx;

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

		fireEvent(new MovedEvent(this, w));

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

	inline function get_chunkIdx():Int
	{
		return pos.toChunkIdx();
	}

	inline function get_chunk():Chunk
	{
		return Game.instance.world.chunks.getChunkById(chunkIdx);
	}

	public function clone(newId:String = null):Entity
	{
		var saved = save();
		saved.id = UniqueId.Create();
		return Entity.Load(saved);
	}

	public function detach()
	{
		isDetached = true;
		if (!has(IsDetached))
		{
			add(new IsDetached());
			registry.detachEntity(id);
		}
	}

	public function reattach()
	{
		registry.reattachEntity(id);
		isDetached = false;
		remove(IsDetached);
	}

	public function save():EntitySaveData
	{
		var cdata = components.flatten().map((c) -> ({
			type: c.type,
			data: c.save(),
		}));

		return {
			id: id,
			pos: {
				x: x,
				y: y,
			},
			isDetachable: isDetachable,
			isDetached: isDetached,
			components: cdata,
		};
	}

	public static function Load(data:EntitySaveData, tickDelta:Int = 0):Entity
	{
		var entity = new Entity(false);
		entity.isCandidacyEnabled = false;
		entity.setId(data.id);

		for (cdata in data.components)
		{
			var clazz = Type.resolveClass(cdata.type);
			if (clazz == null)
			{
				trace('Component not found ($clazz)');
				continue;
			}
			var c = cast(Type.createInstance(clazz, []), Component);
			c._attach(entity);
			c.load(cdata.data);

			entity.add(c);
		}

		entity.pos = new Coordinate(data.pos.x, data.pos.y, WORLD);
		entity.isDetachable = data.isDetachable;
		entity.isDetached = data.isDetached;

		if (entity.isDetached)
		{
			entity.registry.detachEntity(entity.id);
		}

		entity.isCandidacyEnabled = true;
		entity.registry.candidacy(entity);

		entity.fireEvent(new EntityLoadedEvent(tickDelta));

		return entity;
	}
}

typedef ComponentSaveData =
{
	type:String,
	data:Dynamic,
}

typedef EntitySaveData =
{
	id:String,
	pos:
	{
		x:Float, y:Float,
	},
	isDetachable:Bool,
	isDetached:Bool,
	components:Array<ComponentSaveData>,
}
