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
		var destinationId = portal.destinationId;
		var success = Game.instance.world.map.goToPortal(destinationId);
		trace('success? $success');
	}

	function get_portal():PortalData
	{
		return Game.instance.world.map.portals.get(portalId);
	}
}
