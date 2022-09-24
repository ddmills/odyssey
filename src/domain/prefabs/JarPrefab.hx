package domain.prefabs;

import core.Game;
import data.ColorKeys;
import data.LiquidType;
import domain.components.LiquidContainer;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class JarPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var liquidType:LiquidType = options.liquidType == null ? LIQUID_WATER : options.liquidType;
		var volume:Int = options.volume == null ? 0 : options.volume;
		var maxVolume:Int = options.maxVolume == null ? 80 : options.maxVolume;

		var entity = new Entity();

		entity.add(new Sprite(JAR, Game.instance.CLEAR_COLOR, ColorKeys.C_BLUE_1, OBJECTS));
		entity.add(new Moniker('Jar'));
		entity.add(new Loot());
		entity.add(new LiquidContainer(liquidType, volume, maxVolume, true, false, true, false, false));

		return entity;
	}
}