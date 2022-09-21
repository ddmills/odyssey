package domain.prefabs;

import data.LiquidType;
import domain.components.LiquidContainer;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.data.liquids.Liquids;
import ecs.Entity;

class PuddlePrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var liquidType:LiquidType = options.liquidType == null ? LIQUID_WATER : options.liquidType;
		var volume:Int = options.volume == null ? 0 : options.volume;
		var maxVolume:Int = options.maxVolume == null ? 1000 : options.maxVolume;
		var liquid = Liquids.Get(liquidType);

		var entity = new Entity();

		entity.add(new Sprite(PUDDLE_1, liquid.primaryColor, liquid.secondaryColor, OBJECTS));
		entity.add(new Moniker('Puddle'));
		entity.add(new LiquidContainer(liquidType, volume, maxVolume, true, true, false, true, true));

		return entity;
	}
}
