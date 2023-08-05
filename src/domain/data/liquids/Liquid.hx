package domain.data.liquids;

import common.struct.Coordinate;
import data.ColorKey;
import data.LiquidType;
import domain.prefabs.Spawner;
import ecs.Entity;

abstract class Liquid
{
	public var liquidType:LiquidType;
	public var primaryColor:ColorKey;
	public var secondaryColor:ColorKey;
	public var name:String;

	public function new(liquidType:LiquidType, name:String, primaryColor:ColorKey, secondaryColor:ColorKey)
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
