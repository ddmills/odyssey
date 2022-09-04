package domain.prefabs;

import common.struct.Coordinate;
import core.Game;
import data.SpawnableType;
import domain.events.SpawnedEvent;

class Spawner
{
	private var prefabs:Map<SpawnableType, Prefab> = new Map();

	public function new() {}

	public function initialize()
	{
		prefabs.set(PLAYER, new PlayerPrefab());
		prefabs.set(CACTUS, new CactusPrefab());
		prefabs.set(CHEST, new ChestPrefab());
		prefabs.set(LOCKBOX, new LockboxPrefab());
		prefabs.set(PISTOL, new PistolPrefab());
		prefabs.set(SNAKE, new SnakePrefab());
		prefabs.set(STICK, new StickPrefab());
	}

	public function spawn(type:SpawnableType, ?pos:Coordinate, ?options:Dynamic)
	{
		var p = pos == null ? new Coordinate(0, 0, WORLD) : pos;
		var entity = prefabs.get(type).Create(options);

		entity.pos = p;

		entity.fireEvent(new SpawnedEvent());

		return entity;
	}

	public static function Spawn(type:SpawnableType, ?pos:Coordinate, ?options:Dynamic)
	{
		return Game.instance.world.spawner.spawn(type, pos, options);
	}
}
