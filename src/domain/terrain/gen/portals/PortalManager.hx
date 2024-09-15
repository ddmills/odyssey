package domain.terrain.gen.portals;

import common.struct.IntPoint;
import common.util.UniqueId;

typedef PortalData =
{
	id:String,
	position:PortalPosition,
	?destinationId:Null<String>,
}

typedef PortalPosition =
{
	?realmId:String,
	?zoneId:Int,
	?pos:Null<IntPoint>,
}

typedef PortalManagerSave =
{
	portals:Map<String, PortalData>
}

class PortalManager
{
	var portals:Map<String, PortalData>;

	public function new() {}

	public function initialize()
	{
		portals = new Map();
	}

	public function save(teardown:Bool):PortalManagerSave
	{
		return {
			portals: portals
		};

		if (teardown)
		{
			portals = new Map();
		}
	}

	public function load(save:PortalManagerSave)
	{
		portals = save.portals;
	}

	public function register(portal:PortalData)
	{
		portals.set(portal.id, portal);
	}

	public function get(portalId:String):Null<PortalData>
	{
		return portals.get(portalId);
	}

	public function create(position:PortalPosition):PortalData
	{
		var portal = {
			id: UniqueId.Create(),
			position: position,
		};

		register(portal);

		return portal;
	}
}
