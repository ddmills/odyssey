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
		portal.pos = entity.pos.toIntPoint();
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
		var dest = destinationPortal;

		if (dest.isNull())
		{
			trace('no destination');
			return;
		}

		if (dest.pos.isNull())
		{
			// Game.instance.world.chunks.loadChunk(destPos.toChunkIdx());
			var chunks = Game.instance.world.zones.getChunksForZone(dest.zoneId);
			trace('destination is not generated yet!');

			for (c in chunks)
			{
				Game.instance.world.chunks.loadChunk(c.chunkId);
			}

			if (dest.pos.isNull())
			{
				trace('DESTINATION IS STILL NULL');
				return;
			}
		}

		var destPos = dest.pos.asWorld();
		evt.user.remove(Move);
		evt.user.drawable.pos = null;
		evt.user.pos = dest.pos.asWorld();
		evt.user.pos = destPos;
		evt.user.fireEvent(new ConsumeEnergyEvent(1));

		if (evt.user.has(IsPlayer))
		{
			Game.instance.camera.focus = evt.user.pos;
		}
	}

	function get_portal():PortalData
	{
		return Game.instance.world.portals.get(portalId);
	}

	function get_destinationPortal():Null<PortalData>
	{
		return Game.instance.world.portals.get(portal.destinationId);
	}
}
