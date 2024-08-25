package domain.prefabs;

import common.struct.Coordinate;
import core.Game;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.LightBlocker;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.prefabs.decorators.StoneBuiltDecorator;
import domain.terrain.biomes.Biomes;
import ecs.Entity;

class StoneWallPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		var zone = Game.instance.world.zones.getZoneByCoordinate(pos);
		var biome = Biomes.get(zone.primaryBiome);
		var data = biome.getCommonRock();

		entity.add(new Sprite(WALL_0, data.primary, data.secondary, OBJECTS));
		entity.add(new BitmaskSprite([
			BITMASK_CUT_STONE,
			BITMASK_ROCK,
			BITMASK_BRICK,
			BITMASK_WINDOW,
			BITMASK_FENCE_BAR
		]));
		entity.add(new Moniker('Stone wall'));
		entity.add(new Collider());
		entity.add(new LightBlocker());

		StoneBuiltDecorator.Decorate(entity);

		return entity;
	}
}
