package domain.terrain.gen.realms;

import common.struct.IntPoint;
import common.util.UniqueId;
import core.Game;
import data.BiomeType;
import ecs.Entity;

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
		realms = new Map();
		generator = new RealmGenerator();
	}

	// Set the active realm and go to destinationPortalId
	public function setActiveRealm(realmId:String, destinationPortalId:String)
	{
		if (realmId == activeRealmId)
		{
			trace('no change in realm!');
			return;
		}
		else if (hasActiveRealm)
		{
			leaveActiveRealm(destinationPortalId);
		}

		trace('detach player...');
		// detach any entities related to player
		world.player.entity.isDetachable = true;
		world.player.entity.detach();

		// unload all chunks
		world.map.chunks.unloadAllChunks();

		// unload exisitng realm
		if (activeRealmId.hasValue())
		{
			activeRealm.unload();
		}

		// load new realm
		activeRealmId = realmId;
		var realm = get(realmId);
		realm.load();

		trace('reattach player...');
		// attach player entities into new realm at portal position
		world.player.entity.reattach();
	}

	// Leave the active realm and go to destination portalId
	public function leaveActiveRealm(destinationPortalId:String)
	{
		trace('LEAVE ACTIVE REALM');
		activeRealm?.unload();
		activeRealmId = null;
		world.player.entity.isDetachable = true;
		world.player.entity.detach();
	}

	public function setEntityPosition(entity:Entity)
	{
		if (!hasActiveRealm)
		{
			trace('trying to update an entity position when no realm active!');
			return;
		}

		activeRealm.setEntityPosition(entity);
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
}
