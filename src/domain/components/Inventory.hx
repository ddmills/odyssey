package domain.components;

import common.struct.Coordinate;
import core.Game;
import data.AudioKey;
import data.TileKey;
import domain.events.OpenInventoryEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.StashInventoryEvent;
import domain.events.TakeEvent;
import ecs.Component;
import ecs.Entity;
import h2d.Tile;
import screens.entitySelect.EntitySelectScreen;
import screens.inventory.InventoryScreen;

class Inventory extends Component
{
	@save private var _contentIds:Array<String> = [];

	public var openedTile:TileKey;

	@save public var openedAudio:AudioKey;
	@save public var closedAudio:AudioKey;

	public var content(get, never):Array<Entity>;

	public function new()
	{
		addHandler(QueryInteractionsEvent, (evt) -> onQueryInteractions(cast evt));
		addHandler(OpenInventoryEvent, (evt) -> onOpenInventory(cast evt));
		addHandler(StashInventoryEvent, (evt) -> onStashInventory(cast evt));
	}

	public function addLoot(loot:Entity)
	{
		if (loot.has(IsInventoried))
		{
			loot.remove(IsInventoried);
		}
		loot.add(new IsInventoried(entity.id));
		_contentIds.push(loot.id);
	}

	public function removeLoot(loot:Entity)
	{
		loot.remove(IsInventoried);
		_contentIds.remove(loot.id);
	}

	public function dropLoot(loot:Entity, pos:Coordinate = null)
	{
		removeLoot(loot);
		loot.pos = pos == null ? entity.pos : pos;
	}

	public function hasLoot(loot:Entity):Bool
	{
		return _contentIds.contains(loot.id);
	}

	function get_content():Array<Entity>
	{
		return _contentIds
			.map((id) -> entity.registry.getEntity(id))
			.filter((e) -> e != null);
	}

	function onOpenInventory(evt:OpenInventoryEvent)
	{
		executeOpenEffects();
		var screen = new InventoryScreen(evt.opener, entity);
		screen.onClosedlistener = executeCloseEffects;
		Game.instance.screens.push(screen);
	}

	function onStashInventory(evt:StashInventoryEvent)
	{
		executeOpenEffects();
		var fetchEntities = () -> evt.stasher.get(Inventory).content;
		var screen = new EntitySelectScreen(fetchEntities());
		screen.onClosedlistener = executeCloseEffects;
		screen.fetchEntities = fetchEntities;
		screen.onSelect = (e:Entity) ->
		{
			e.fireEvent(new TakeEvent(entity));
			Game.instance.screens.pop();
			return;
		};
		Game.instance.screens.push(screen);
	}

	function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		evt.interactions.push({
			name: 'Open',
			evt: new OpenInventoryEvent(evt.interactor),
		});

		if (evt.interactor.has(Inventory))
		{
			evt.interactions.push({
				name: 'Stash',
				evt: new StashInventoryEvent(evt.interactor),
			});
		}
	}

	private function executeOpenEffects()
	{
		if (openedTile != null && entity.has(Sprite))
		{
			entity.get(Sprite).overrideTileKey = openedTile;
		}
		Game.instance.audio.play(openedAudio);
	}

	private function executeCloseEffects()
	{
		if (openedTile != null && entity.has(Sprite))
		{
			entity.get(Sprite).overrideTileKey = null;
		}
		Game.instance.audio.play(closedAudio);
	}
}
