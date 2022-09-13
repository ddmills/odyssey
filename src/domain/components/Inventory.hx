package domain.components;

import common.struct.Coordinate;
import core.Game;
import data.AudioKey;
import data.StackableType;
import data.TileKey;
import domain.events.MovedEvent;
import domain.events.OpenInventoryEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.StashInventoryEvent;
import domain.events.TakeEvent;
import ecs.Component;
import ecs.Entity;
import screens.entitySelect.EntitySelectScreen;
import screens.inventory.InventoryScreen;
import screens.prompt.NumberPromptScreen;

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
		addHandler(MovedEvent, (evt) -> onMoved(cast evt));
	}

	public function addLoot(loot:Entity)
	{
		if (loot.has(IsInventoried))
		{
			loot.remove(IsInventoried);
		}

		if (loot.has(Stackable) && !loot.has(IsEquipped))
		{
			var existing = getStackable(loot.get(Stackable).stackType);

			if (existing != null)
			{
				loot.get(Stackable).addOther(existing.get(Stackable));
				_contentIds.remove(existing.id);
			}
		}

		loot.add(new IsInventoried(entity.id));
		_contentIds.push(loot.id);
	}

	public function removeLoot(loot:Entity, ?quantity:Int, ?removeClone:Bool = true)
	{
		loot.remove(IsInventoried);
		_contentIds.remove(loot.id);

		var stack = loot.get(Stackable);

		if (stack == null || quantity == null || quantity >= stack.quantity)
		{
			if (loot.has(IsEquipped))
			{
				loot.get(IsEquipped).slot.unequip();
			}
			return loot;
		}

		var clone = loot.clone();
		if (removeClone)
		{
			clone.get(Stackable).quantity = quantity;
			stack.quantity -= quantity;

			addLoot(loot);

			return clone;
		}
		else
		{
			clone.get(Stackable).quantity -= quantity;
			stack.quantity = quantity;

			addLoot(clone);

			return loot;
		}
	}

	public function dropLoot(loot:Entity, pos:Coordinate = null, ?quantity:Int)
	{
		var l = removeLoot(loot, quantity);
		l.pos = pos == null ? entity.pos : pos;
		return l;
	}

	public function hasLoot(loot:Entity):Bool
	{
		return _contentIds.contains(loot.id);
	}

	public function combineStackables(stackType:StackableType, targetStackableId:String)
	{
		var loose = content.filter((e) ->
		{
			return e.has(Stackable) && e.get(Stackable).stackType == stackType && !e.has(IsEquipped);
		});
		var target = loose.find((e) -> e.id == targetStackableId);

		if (target == null)
		{
			return;
		}

		var stack = target.get(Stackable);
		for (e in loose)
		{
			if (e.id == targetStackableId)
			{
				continue;
			}
			stack.addOther(e.get(Stackable));
			e.remove(IsInventoried);
			_contentIds.remove(e.id);
		}
	}

	function getStackable(stackType:StackableType)
	{
		return content.find((e) ->
		{
			return e.has(Stackable) && e.get(Stackable).stackType == stackType && !e.has(IsEquipped);
		});
	}

	function get_content():Array<Entity>
	{
		return _contentIds
			.map((id) -> entity.registry.getEntity(id))
			.filter((e) -> e != null);
	}

	function onMoved(evt:MovedEvent)
	{
		for (e in content)
		{
			e.fireEvent(evt);
		}
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
			var stack = e.get(Stackable);
			if (stack == null || stack.quantity == 1)
			{
				if (e.has(IsEquipped))
				{
					e.get(IsEquipped).slot.unequip(false);
				}
				e.get(Loot).take(entity);
				Game.instance.screens.pop();
			}
			else
			{
				var s = new NumberPromptScreen();
				s.title = 'How many to stash? (${stack.quantity} total)';
				s.setValue(stack.quantity);
				s.onAccept = (_) ->
				{
					if (s.value > 0)
					{
						e.get(Loot).take(entity, s.value);
					}
					Game.instance.screens.pop();
					Game.instance.screens.pop();
				}
				Game.instance.screens.push(s);
			}
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
			entity.get(Sprite).tileKeyOverride = openedTile;
		}
		Game.instance.world.playAudio(entity.pos.toIntPoint(), openedAudio);
	}

	private function executeCloseEffects()
	{
		if (openedTile != null && entity.has(Sprite))
		{
			entity.get(Sprite).tileKeyOverride = null;
		}
		Game.instance.world.playAudio(entity.pos.toIntPoint(), closedAudio);
	}
}
