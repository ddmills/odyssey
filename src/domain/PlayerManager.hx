package domain;

import common.struct.Coordinate;
import data.save.SaveWorld.SavePlayer;
import domain.prefabs.Spawner;
import ecs.Entity;
import ecs.EntityRef;

class PlayerManager
{
	private var entityRef:EntityRef;

	public var entity(get, never):Entity;
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var pos(get, set):Coordinate;

	inline function get_entity():Entity
	{
		return entityRef.entity;
	}

	public function new()
	{
		entityRef = new EntityRef();
	}

	public function initialize() {}

	public function create(pos:Coordinate)
	{
		entityRef.entity = Spawner.Spawn(PLAYER, pos);
	}

	public function save(?teardown:Bool = false):SavePlayer
	{
		entity.detach();
		var data = entity.save();

		if (teardown)
		{
			entity.destroy();
		}

		return {
			entity: data,
		};
	}

	public function load(data:SavePlayer)
	{
		entityRef.entity = Entity.Load(data.entity);
		entityRef.entity.reattach();
	}

	inline function get_x():Float
	{
		return entity.x;
	}

	inline function get_y():Float
	{
		return entity.y;
	}

	inline function get_pos():Coordinate
	{
		return entity.pos;
	}

	inline function set_pos(value:Coordinate):Coordinate
	{
		return entity.pos = value;
	}

	inline function set_y(value:Float):Float
	{
		return entity.y = value;
	}

	inline function set_x(value:Float):Float
	{
		return entity.x = value;
	}
}
