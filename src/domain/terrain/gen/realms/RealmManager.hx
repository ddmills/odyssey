package domain.terrain.gen.realms;

import common.struct.IntPoint;
import common.tools.Performance;
import common.util.UniqueId;
import core.Game;
import data.BiomeType;
import domain.terrain.gen.realms.Realm.RealmMetaDataSave;
import ecs.Entity;
import h2d.Bitmap;

enum RealmType
{
	REALM_BASEMENT;
}

typedef RealmDefinition =
{
	type:RealmType,
	worldPos:IntPoint,
	settings:Dynamic,
}

typedef RealmManagerSave =
{
	realms:Array<RealmMetaDataSave>,
	activeRealmId:Null<String>,
}

class RealmManager implements MapDataStore
{
	private var game(get, never):Game;
	private var world(get, never):World;

	var realms:Map<String, Realm>;

	public var activeRealmId(default, null):Null<String>;
	public var activeRealm(get, never):Null<Realm>;
	public var hasActiveRealm(get, never):Bool;

	public var generator:RealmGenerator;

	public function new() {}

	public function initialize()
	{
		activeRealmId = null;
		realms = new Map();
		generator = new RealmGenerator();
	}

	public function save(teardown:Bool):RealmManagerSave
	{
		var loaded = realms.filter((r) -> r.isLoaded).map((r) -> r.realmId);

		for (realmId in loaded)
		{
			saveRealm(realmId, teardown);
		}

		var save = {
			realms: realms.map((r) -> r.saveMetaData()),
			activeRealmId: activeRealmId
		};

		if (teardown)
		{
			realms = new Map();
			activeRealmId = null;
		}

		return save;
	}

	public function load(save:RealmManagerSave)
	{
		realms = new Map();
		activeRealmId = null;

		for (r in save.realms)
		{
			var realm = Realm.CreateMetaData(r);
			register(realm);
		}

		if (save.activeRealmId.hasValue())
		{
			setActiveRealm(save.activeRealmId);
		}
	}

	public function setActiveRealm(realmId:String)
	{
		if (realmId == activeRealmId)
		{
			trace('no change in realm!');
			return;
		}
		else if (hasActiveRealm)
		{
			leaveActiveRealm();
		}

		// unload all chunks
		world.map.chunks.unloadAllChunks();

		// unload exisitng realm
		if (activeRealmId.hasValue())
		{
			activeRealm.unload();
		}

		// load new realm
		activeRealmId = realmId;
		loadRealm(realmId);
	}

	public function leaveActiveRealm()
	{
		if (activeRealmId.hasValue())
		{
			saveRealm(activeRealmId, true);
			activeRealm?.unload();
			activeRealmId = null;
		}
		world.player.entity.isDetachable = true;
		world.player.entity.detach();
	}

	private function saveRealm(realmId:String, unload:Bool)
	{
		var realm = get(realmId);
		Performance.start('realm-save');
		var data = realm.save();
		Performance.stop('realm-save');
		game.files.saveRealm(data);
		if (unload)
		{
			realm.unload();
		}
	}

	private function loadRealm(realmId:String)
	{
		var realm = get(realmId);
		var data = game.files.tryReadRealm(realmId);

		if (data != null)
		{
			Performance.start('realm-load');
			realm.load(data);
			Performance.stop('realm-load');
		}
		else
		{
			Performance.start('realm-gen');
			realm.load();
			Performance.stop('realm-gen');
		}
	}

	public function updateEntityPosition(entity:Entity, targetWorldPos:IntPoint)
	{
		if (!hasActiveRealm)
		{
			trace('trying to update an entity position when no realm active!');
			return;
		}

		activeRealm.updateEntityPosition(entity, targetWorldPos);
	}

	public function register(realm:Realm)
	{
		realms.set(realm.realmId, realm);
	}

	public function get(realmId:String):Null<Realm>
	{
		return realms.get(realmId);
	}

	public function create(definition:RealmDefinition)
	{
		var realm = new Realm(UniqueId.Create(), Game.instance.world.zoneSize, definition.worldPos, definition);
		register(realm);

		return realm;
	}

	function get_activeRealm():Null<Realm>
	{
		if (activeRealmId.hasValue())
		{
			return get(activeRealmId);
		}

		return null;
	}

	inline function get_game():Game
	{
		return Game.instance;
	}

	inline function get_world():World
	{
		return Game.instance.world;
	}

	inline function get_hasActiveRealm():Bool
	{
		return activeRealmId.hasValue();
	}

	public function getEntityIdsAt(worldPos:IntPoint):Array<String>
	{
		return activeRealm.getEntityIdsAt(worldPos);
	}

	public function getBiomeType(worldPos:IntPoint):BiomeType
	{
		return BiomeType.SWAMP;
	}

	public function setVisible(worldPos:IntPoint)
	{
		setExplore(worldPos, true, true);
	}

	public function setExplore(worldPos:IntPoint, isExplored:Bool, isVisible:Bool)
	{
		var localPos = activeRealm.worldPositionToRealmLocal(worldPos);
		activeRealm.setExplore(localPos, isExplored, isVisible);
	}

	public function isExplored(worldPos:IntPoint):Bool
	{
		var localPos = activeRealm.worldPositionToRealmLocal(worldPos);
		return activeRealm.isExplored(localPos);
	}

	public function getCell(worldPos:IntPoint):Cell
	{
		var localPos = activeRealm.worldPositionToRealmLocal(worldPos);
		return activeRealm.getCell(localPos);
	}

	public function getBackgroundBitmap(worldPos:IntPoint):Bitmap
	{
		var localPos = activeRealm.worldPositionToRealmLocal(worldPos);
		return activeRealm.getGroundBitmap(localPos);
	}

	public function getAmbientLighting():Float
	{
		return activeRealm.getAmbientLighting();
	}
}
