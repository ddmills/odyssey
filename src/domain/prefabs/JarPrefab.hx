package domain.prefabs;

import common.struct.Coordinate;
import core.Game;
import data.ColorKey;
import data.LiquidType;
import domain.components.Destructable;
import domain.components.LiquidContainer;
import domain.components.Loot;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class JarPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var liquidType:LiquidType = options.liquidType == null ? LIQUID_WATER : options.liquidType;
		var volume:Int = options.volume == null ? 0 : options.volume;
		var maxVolume:Int = options.maxVolume == null ? 80 : options.maxVolume;

		var entity = new Entity(pos);

		entity.add(new Sprite(JAR, Game.instance.CLEAR_COLOR, C_BLUE_1, OBJECTS));
		entity.add(new Moniker('Jar'));
		entity.add(new Loot());
		entity.add(new LiquidContainer(liquidType, volume, maxVolume, true, false, true, false, false));
		entity.add(new Destructable());

		return entity;
	}
}
