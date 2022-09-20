package domain.data.liquids;

import common.struct.Coordinate;
import data.LiquidType;
import domain.components.LiquidContainer;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.events.EntitySpawnedEvent;
import domain.prefabs.Spawner;
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
		return Spawner.Spawn(PUDDLE, pos, {
			liquidType: liquidType,
			volume: volume,
		});
	}
}
