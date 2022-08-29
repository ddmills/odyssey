package domain;

import common.struct.Coordinate;
import data.TileResources;
import domain.components.Energy;
import domain.components.Glyph;
import domain.components.IsPlayer;
import ecs.Entity;
import ecs.EntityRef;

class PlayerManager
{
	var entityRef:EntityRef;

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

	public function initialize()
	{
		var e = new Entity();

		e.add(new Glyph(TileResources.HERO, 0xd8cfbd, 0x7e3e32, ACTORS));
		e.add(new IsPlayer());
		e.add(new Energy());

		entityRef.entity = e;
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
