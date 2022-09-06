package domain.prefabs;

import common.struct.Coordinate;
import core.Game;
import data.SpawnableType;
import domain.events.SpawnedEvent;
import domain.prefabs.BloodSpatterPrefab.BloodSplatterPrefab;

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
		prefabs.set(NAVY_REVOLVER, new NavyRevoloverPrefab());
		prefabs.set(RIFLE, new RiflePrefab());
		prefabs.set(SNAKE, new SnakePrefab());
		prefabs.set(SNAKE_CORPSE, new SnakeCorpsePrefab());
		prefabs.set(STICK, new StickPrefab());
		prefabs.set(PONCHO, new PonchoPrefab());
		prefabs.set(DUSTER, new DusterPrefab());
		prefabs.set(LONG_JOHNS, new LongJohnsPrefab());
		prefabs.set(BULLET, new BulletPrefab());
		prefabs.set(BLOOD_SPATTER, new BloodSplatterPrefab());
		prefabs.set(COACH_GUN, new CoachGunPrefab());
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
