package domain.terrain.gen.realms;

import core.Game;
import data.BiomeType;
import data.TileKey;
import domain.prefabs.Spawner;

class RealmGenerator
{
	private var seed(get, null):Int;
	private var world(get, null):World;

	public function new() {}

	public function generate(realm:Realm)
	{
		trace('generate realm ${realm.realmId} ${realm.worldPos.toString()}');

		realm.cells.fillFn((idx) -> {
			idx: idx,
			terrain: TerrainType.TERRAIN_SAND,
			biomeKey: BiomeType.DESERT,
			tileKey: TileKey.TERRAIN_BASIC_1,
			primary: 0x007777,
			secondary: 0x770077,
			background: 0x000077,
			isRailroad: false,
		});

		Spawner.Spawn(SIGNPOST, realm.worldPos.add(5, 5).asWorld());

		var portalIds:Array<String> = realm.definition.settings.portalIds;

		for (portalId in portalIds)
		{
			var portal = world.portals.get(portalId);
			var pos = realm.worldPos.add(5, 10);
			Spawner.Spawn(STAIR_UP, pos.asWorld(), {
				portalId: portalId,
			});
			portal.position.pos = pos;
		}
	}

	inline function get_seed():Int
	{
		return Game.instance.world.seed;
	}

	inline function get_world():World
	{
		return Game.instance.world;
	}
}
