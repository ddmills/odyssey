package domain.components;

import core.Game;
import data.AudioKey;
import data.TileKey;
import domain.events.CloseDoorEvent;
import domain.events.EntitySpawnedEvent;
import domain.events.OpenDoorEvent;
import domain.events.QueryInteractionsEvent;
import domain.systems.EnergySystem;
import ecs.Component;

class Door extends Component
{
	@save public var isOpen:Bool = false;
	@save public var overrideLightBlocker:Bool = true;
	@save public var overrideCollider:Bool = true;
	@save public var openedTile:TileKey;
	@save public var openedAudio:AudioKey;
	@save public var closedAudio:AudioKey;

	public var displayName(get, never):String;

	public function new(openedTile:TileKey, overrideLightBlocker:Bool = true)
	{
		this.openedTile = openedTile;
		this.overrideLightBlocker = overrideLightBlocker;

		addHandler(QueryInteractionsEvent, onQueryInteractions);
		addHandler(CloseDoorEvent, onCloseDoor);
		addHandler(OpenDoorEvent, onOpenDoor);
		addHandler(EntitySpawnedEvent, (evt) -> applyOverrides());
	}

	public function openDoor():Bool
	{
		if (isOpen)
		{
			return false;
		}

		isOpen = true;
		applyOverrides();

		if (openedAudio != null)
		{
			Game.instance.world.playAudio(entity.pos.toIntPoint(), openedAudio);
		}

		return true;
	}

	public function closeDoor():Bool
	{
		if (!isOpen)
		{
			return false;
		}

		isOpen = false;
		applyOverrides();

		if (closedAudio != null)
		{
			Game.instance.world.playAudio(entity.pos.toIntPoint(), closedAudio);
		}

		return true;
	}

	private function applyOverrides()
	{
		if (openedTile != null && entity.has(Sprite))
		{
			entity.get(Sprite).tileKeyOverride = isOpen ? openedTile : null;
		}

		if (overrideCollider)
		{
			if (isOpen)
			{
				entity.remove(Collider);
			}
			else
			{
				entity.add(new Collider());
			}
		}

		if (overrideLightBlocker)
		{
			if (isOpen)
			{
				entity.remove(LightBlocker);
			}
			else
			{
				entity.add(new LightBlocker());
			}
		}
	}

	private function onCloseDoor(evt:CloseDoorEvent)
	{
		if (closeDoor())
		{
			EnergySystem.ConsumeEnergy(evt.closer, ACT_DOOR_CLOSE);
		}
	}

	private function onOpenDoor(evt:OpenDoorEvent)
	{
		if (openDoor())
		{
			EnergySystem.ConsumeEnergy(evt.opener, ACT_DOOR_OPEN);
		}
	}

	private function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (isOpen)
		{
			evt.interactions.push({
				evt: new CloseDoorEvent(evt.interactor),
				name: 'Close door',
			});
		}
		else
		{
			evt.interactions.push({
				evt: new OpenDoorEvent(evt.interactor),
				name: 'Open door',
			});
		}
	}

	function get_displayName():String
	{
		return isOpen ? 'open' : 'closed';
	}
}
