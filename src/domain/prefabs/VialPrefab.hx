package domain.prefabs;

import common.struct.Coordinate;
import core.Game;
import data.LiquidType;
import domain.components.Destructable;
import domain.components.LiquidContainer;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.components.Throwable;
import ecs.Entity;

class VialPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var liquidType:LiquidType = options.liquidType ?? LIQUID_WATER;
		var volume:Int = options.volume ?? 0;
		var maxVolume:Int = options.maxVolume ?? 80;

		var entity = new Entity(pos);

		entity.add(new Sprite(VIAL, C_CLEAR, C_BLUE, OBJECTS));
		entity.add(new Moniker('Vial'));
		entity.add(new Loot());
		entity.add(new LiquidContainer(liquidType, volume, maxVolume, true, false, true, false, false));
		entity.add(new Destructable());
		entity.add(new Throwable());

		return entity;
	}
}
