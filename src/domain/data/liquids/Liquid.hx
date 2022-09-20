package domain.data.liquids;

import common.struct.Coordinate;
import data.LiquidType;
import domain.components.LiquidContainer;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.events.EntitySpawnedEvent;
import ecs.Entity;

abstract class Liquid
{
	public var liquidType:LiquidType;
	public var primaryColor:Int;
	public var secondaryColor:Int;
	public var name:String;

	public function new(liquidType:LiquidType, name:String, primaryColor:Int, secondaryColor:Int)
	{
		this.liquidType = liquidType;
		this.name = name;
		this.primaryColor = primaryColor;
		this.secondaryColor = secondaryColor;
	}

	public function createPuddle(pos:Coordinate, volume:Int):Entity
	{
		var entity = new Entity();

		entity.add(new Sprite(PUDDLE_1, primaryColor, secondaryColor, GROUND));
		entity.add(new Moniker('Puddle'));
		entity.add(new LiquidContainer(liquidType, volume, 1000, true, true, false, true, true));
		entity.fireEvent(new EntitySpawnedEvent());
		entity.pos = pos;

		return entity;
	}
}
