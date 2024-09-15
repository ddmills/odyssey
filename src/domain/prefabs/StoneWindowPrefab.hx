package domain.prefabs;

import common.struct.Coordinate;
import core.Game;
import domain.components.BitmaskSprite;
import domain.components.Collider;
import domain.components.Moniker;
import domain.components.Sprite;
import domain.terrain.biomes.Biomes;
import ecs.Entity;

class StoneWindowPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var entity = new Entity(pos);

		// todo: consider realm biome
		var zone = Game.instance.world.map.zones.getZoneByCoordinate(pos);
		var biome = Biomes.get(zone.primaryBiome);
		var data = biome.getCommonRock();

		entity.add(new Sprite(WALL_WINDOW_H, data.primary, C_BLUE, OBJECTS));
		entity.add(new BitmaskSprite([
			BITMASK_WINDOW,
			BITMASK_WALL,
			BITMASK_BRICK,
			BITMASK_CUT_STONE,
			BITMASK_WALL_THICK
		]));
		entity.add(new Moniker('Window'));
		entity.add(new Collider());

		return entity;
	}
}
