package domain.prefabs;

import data.LiquidType;
import domain.components.LiquidContainer;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class VialPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var liquidType:LiquidType = options.liquidType == null ? LIQUID_WATER : options.liquidType;
		var volume:Int = options.volume == null ? 0 : options.volume;
		var maxVolume:Int = options.maxVolume == null ? 80 : options.maxVolume;

		var entity = new Entity();

		entity.add(new Sprite(VIAL, 0x8ac1ee, 0x121213, OBJECTS));
		entity.add(new Moniker('Vial'));
		entity.add(new Loot());
		entity.add(new LiquidContainer(liquidType, volume, maxVolume, true, true, true, false, false));

		return entity;
	}
}
