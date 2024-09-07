package domain.terrain.gen.portals;

import common.struct.IntPoint;
import common.util.UniqueId;
import data.SpawnableType;

typedef PortalData =
{
	id:String,
	spawnable:SpawnableType,
	?name:Null<String>,
	?destinationId:Null<String>,
	zoneId:Int,
	?chunkId:Null<Int>,
	?pos:Null<IntPoint>,
}

class PortalManager
{
	var portals:Map<String, PortalData>;

	public function new() {}

	public function initialize()
	{
		portals = new Map();
	}

	public function register(portal:PortalData)
	{
		portals.set(portal.id, portal);
	}

	public function get(portalId:String):Null<PortalData>
	{
		return portals.get(portalId);
	}

	public function getByName(name:String):Null<PortalData>
	{
		return portals.find((p) -> p.name == name);
	}

	public function create(spawnable:SpawnableType, zoneId:Int, ?name:String):PortalData
	{
		var portal = {
			id: UniqueId.Create(),
			spawnable: spawnable,
			zoneId: zoneId,
			name: name,
		};

		register(portal);

		return portal;
	}
}
