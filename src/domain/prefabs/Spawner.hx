package domain.prefabs;

import common.struct.Coordinate;
import core.Game;
import data.SpawnableType;
import domain.events.EntitySpawnedEvent;
import domain.prefabs.BloodSpatterPrefab.BloodSplatterPrefab;
import domain.prefabs.NavyRevolverPrefab;

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
		prefabs.set(NAVY_REVOLVER, new NavyRevolverPrefab());
		prefabs.set(SNUB_NOSE_REVOLVER, new SnubNoseRevolverPrefab());
		prefabs.set(REVOLVER, new RevolverPrefab());
		prefabs.set(RIFLE, new RiflePrefab());
		prefabs.set(WOLF, new WolfPrefab());
		prefabs.set(YARROW, new YarrowPrefab());
		prefabs.set(YARROW_LEAF, new YarrowLeafPrefab());
		prefabs.set(HEMLOCK, new HemlockPrefab());
		prefabs.set(LAVENDER, new LavenderPrefab());
		prefabs.set(RASPBERRY, new RaspberryPrefab());
		prefabs.set(RASPBERRY_BUSH, new RaspberryBushPrefab());
		prefabs.set(SNAKE, new SnakePrefab());
		prefabs.set(CORPSE_HUMAN, new HumanCorpsePrefab());
		prefabs.set(CORPSE_SNAKE, new SnakeCorpsePrefab());
		prefabs.set(STICK, new StickPrefab());
		prefabs.set(PONCHO, new PonchoPrefab());
		prefabs.set(DUSTER, new DusterPrefab());
		prefabs.set(LONG_JOHNS, new LongJohnsPrefab());
		prefabs.set(BULLET, new BulletPrefab());
		prefabs.set(BLOOD_SPATTER, new BloodSplatterPrefab());
		prefabs.set(BLOOD_SPURT, new BloodSpurtPrefab());
		prefabs.set(COACH_GUN, new CoachGunPrefab());
		prefabs.set(THUG, new ThugPrefab());
		prefabs.set(THUG_2, new ThugPistolPrefab());
		prefabs.set(PISTOL_AMMO, new PistolAmmoPrefab());
		prefabs.set(RIFLE_AMMO, new RifleAmmoPrefab());
		prefabs.set(SHOTGUN_AMMO, new ShotgunAmmoPrefab());
		prefabs.set(BALD_CYPRESS, new BaldCypressPrefab());
		prefabs.set(PINE_TREE, new PineTreePrefab());
		prefabs.set(OAK_TREE, new OakTreePrefab());
		prefabs.set(CAMPFIRE, new CampfirePrefab());
		prefabs.set(LANTERN, new LanternPrefab());
		prefabs.set(ASHES, new AshPilePrefab());
		prefabs.set(VIAL, new VialPrefab());
		prefabs.set(JAR, new JarPrefab());
		prefabs.set(PUDDLE, new PuddlePrefab());
		prefabs.set(VIAL_WHISKEY, new VialWhiskeyPrefab());
		prefabs.set(WAGON_WHEEL, new WagonWheelPrefab());
		prefabs.set(TOMBSTONE, new TombstonePrefab());
		prefabs.set(BOOTS, new BootsPrefab());
		prefabs.set(COWBOY_HAT, new CowboyHatPrefab());
		prefabs.set(PANTS, new PantsPrefab());
		prefabs.set(WOOD_WALL, new WoodWallPrefab());
		prefabs.set(WOOD_WALL_WINDOW, new WindowPrefab());
		prefabs.set(WOOD_DOOR, new WoodDoorPrefab());
		prefabs.set(WOOD_PLANK, new WoodPlankPrefab());
		prefabs.set(TABLE, new TablePrefab());
		prefabs.set(CHAIR, new ChairPrefab());
		prefabs.set(CABINET, new CabinetPrefab());
		prefabs.set(TALL_CABINET, new TallCabinetPrefab());
		prefabs.set(SHELF, new ShelfPrefab());
		prefabs.set(BOOKSHELF, new BookshelfPrefab());
		prefabs.set(FENCE_BARBED, new FenceBarbedPrefab());
		prefabs.set(FENCE_IRON, new FenceIronPrefab());
		prefabs.set(FENCE_BARS, new FenceBarsPrefab());
		prefabs.set(BARS_DOOR, new BarsDoorPrefab());
		prefabs.set(RAILROAD, new RailroadPrefab());
		prefabs.set(VILLAGER, new VillagerPrefab());
		prefabs.set(BEDROLL, new BedrollPrefab());
		prefabs.set(DYNAMITE, new DynamitePrefab());
		prefabs.set(EXPLOSION, new ExplosionPrefab());
		prefabs.set(LOG, new LogPrefab());
		prefabs.set(DESERT_ROCK, new DesertRockPrefab());
		prefabs.set(ROCK, new RockPrefab());
		prefabs.set(CACTUS_FRUIT, new CactusFruitPrefab());
		prefabs.set(FLOATING_TEXT, new FloatingTextPrefab());
	}

	public function spawn(type:SpawnableType, ?pos:Coordinate, ?options:Dynamic, ?isDetachable:Bool)
	{
		var p = pos == null ? new Coordinate(0, 0, WORLD) : pos.toWorld().floor();
		var o = options == null ? {} : options;
		var d = isDetachable == null ? false : isDetachable;
		var entity = prefabs.get(type).Create(o, p);

		if (d)
		{
			entity.isDetachable = true;
		}

		entity.pos = p;

		entity.fireEvent(new EntitySpawnedEvent());

		return entity;
	}

	public static function Spawn(type:SpawnableType, ?pos:Coordinate, ?options:Dynamic, ?isDetachable:Bool)
	{
		return Game.instance.world.spawner.spawn(type, pos, options, isDetachable);
	}
}
