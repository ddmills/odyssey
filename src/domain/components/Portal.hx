package domain.components;

import core.Game;
import domain.events.ConsumeEnergyEvent;
import domain.events.EntitySpawnedEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.UsePortalEvent;
import domain.terrain.gen.portals.PortalManager.PortalData;
import ecs.Component;

class Portal extends Component
{
	@save public var portalId:String;

	public var portal(get, never):PortalData;
	public var destinationPortal(get, never):Null<PortalData>;

	public function new(portalId:String)
	{
		this.portalId = portalId;

		this.addHandler(EntitySpawnedEvent, onEntitySpawned);
		this.addHandler(QueryInteractionsEvent, onQueryInteraction);
		this.addHandler(UsePortalEvent, onUsePortal);
	}

	private function onEntitySpawned(evt:EntitySpawnedEvent)
	{
		trace('update portal with new pos etc', entity.pos.toString());
		portal.position.pos = entity.pos.toIntPoint();
	}

	private function onQueryInteraction(evt:QueryInteractionsEvent)
	{
		if (!portal.destinationId.isNull())
		{
			evt.add({
				evt: new UsePortalEvent(evt.interactor),
				name: 'Use portal',
			});
		}
	}

	private function onUsePortal(evt:UsePortalEvent)
	{
		trace('teleport!');
		var success = Game.instance.world.map.usePortal(portalId);

		trace('success? $success');
		// var dest = destinationPortal;

		// if (dest.isNull())
		// {
		// 	trace('no destination');
		// 	return;
		// }

		// if (dest.position.pos.isNull())
		// {
		// 	// check if it has a zone
		// 	if (dest.position.zoneId.hasValue())
		// 	{
		// 		if (Game.instance.world.realms.hasActiveRealm)
		// 		{
		// 			Game.instance.world.realms.leaveActiveRealm(dest.id);
		// 		}
		// 		var chunks = Game.instance.world.zones.getChunksForZone(dest.position.zoneId);
		// 		for (c in chunks)
		// 		{
		// 			Game.instance.world.chunks.loadChunk(c.chunkId);
		// 		}
		// 	}
		// 	else if (dest.position.realmId.hasValue())
		// 	{
		// 		trace('PORTAL TO REALM ${dest.position.realmId}');
		// 		Game.instance.world.realms.setActiveRealm(dest.position.realmId, dest.id);
		// 		return;
		// 	}

		// 	// Game.instance.world.chunks.loadChunk(destPos.toChunkIdx());
		// 	trace('destination is not generated yet!');

		// 	if (dest.position.pos.isNull())
		// 	{
		// 		trace('DESTINATION IS STILL NULL');
		// 		return;
		// 	}
		// }

		// var destRealm = dest.position.realmId;

		// if (destRealm.hasValue())
		// {
		// 	Game.instance.world.realms.setActiveRealm(destRealm, dest.id);
		// }
		// else
		// {
		// 	Game.instance.world.realms.leaveActiveRealm(dest.id);
		// 	var chunks = Game.instance.world.zones.getChunksForZone(dest.position.zoneId);
		// 	for (c in chunks)
		// 	{
		// 		Game.instance.world.chunks.loadChunk(c.chunkId);
		// 	}
		// 	Game.instance.world.player.entity.reattach();
		// }

		// var destPos = dest.position.pos.asWorld();
		// evt.user.remove(Move);
		// evt.user.drawable.pos = null;
		// evt.user.pos = dest.position.pos.asWorld();
		// evt.user.pos = destPos;
		// evt.user.fireEvent(new ConsumeEnergyEvent(1));

		// if (evt.user.has(IsPlayer))
		// {
		// 	Game.instance.camera.focus = evt.user.pos;
		// }
	}

	function get_portal():PortalData
	{
		return Game.instance.world.map.portals.get(portalId);
	}

	function get_destinationPortal():Null<PortalData>
	{
		return Game.instance.world.map.portals.get(portal.destinationId);
	}
}
