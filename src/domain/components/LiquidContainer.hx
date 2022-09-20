package domain.components;

import common.struct.Coordinate;
import core.Game;
import data.LiquidType;
import domain.data.liquids.Liquid;
import domain.data.liquids.Liquids;
import domain.events.EntityLoadedEvent;
import domain.events.EntitySpawnedEvent;
import domain.events.GatherLiquidEvent;
import domain.events.PourEvent;
import domain.events.QueryInteractionsEvent;
import ecs.Component;
import ecs.Entity;
import screens.entitySelect.EntitySelectScreen;
import screens.inventory.LiquidPourScreen;
import screens.prompt.NumberPromptScreen;

class LiquidContainer extends Component
{
	@save public var liquidType:LiquidType;
	@save public var volume:Int;
	@save public var maxVolume:Int;
	@save public var overridePrimary:Bool;
	@save public var overrideSecondary:Bool;
	@save public var isPourable:Bool;
	@save public var isGatherable:Bool;
	@save public var destroyOnEmpty:Bool;

	public var liquid(get, never):Liquid;
	public var isEmpty(get, never):Bool;
	public var isFull(get, never):Bool;
	public var remainingVolume(get, never):Int;
	public var displayName(get, never):String;

	public function new(liquidType:LiquidType = LIQUID_WATER, volume:Int = 0, maxVolume:Int = 100, overridePrimary:Bool = false,
			overrideSecondary:Bool = false, isPourable:Bool = false, isGatherable:Bool = false, destroyOnEmpty:Bool = false)
	{
		this.liquidType = liquidType;
		this.volume = volume;
		this.maxVolume = maxVolume;
		this.overridePrimary = overridePrimary;
		this.overrideSecondary = overrideSecondary;
		this.isPourable = isPourable;
		this.isGatherable = isGatherable;
		this.destroyOnEmpty = destroyOnEmpty;

		addHandler(PourEvent, onPour);
		addHandler(QueryInteractionsEvent, onQueryInteractions);
		addHandler(EntityLoadedEvent, onEntityLoaded);
		addHandler(EntitySpawnedEvent, onEntitySpawned);
		addHandler(GatherLiquidEvent, onGatherLiquid);
	}

	public function addLiquid(liquidType:LiquidType, quantity:Int):Int
	{
		if (!isEmpty && liquidType != this.liquidType)
		{
			return quantity;
		}
		this.liquidType = liquidType;

		var leftover = 0;

		if (quantity >= remainingVolume)
		{
			leftover = quantity - remainingVolume;
			volume = maxVolume;
		}
		else
		{
			volume += quantity;
		}

		applyColorOverrides();

		return leftover;
	}

	public function pour(pos:Coordinate, quantity:Int):Bool
	{
		if (quantity <= 0 || isEmpty || !isPourable)
		{
			return false;
		}

		if (quantity >= volume)
		{
			quantity = volume;
		}

		volume -= quantity;

		liquid.createPuddle(pos, quantity);

		checkDestroyOnEmpty();
		applyColorOverrides();

		return true;
	}

	public function pourInto(target:Entity, quantity:Int)
	{
		var container = target.get(LiquidContainer);
		if (container == null)
		{
			return false;
		}

		var leftover = container.addLiquid(liquidType, quantity);
		volume -= (quantity - leftover);

		checkDestroyOnEmpty();
		applyColorOverrides();

		return true;
	}

	private function onPour(evt:PourEvent)
	{
		var s = new LiquidPourScreen(this, evt.pourer);
		Game.instance.screens.push(s);
	}

	private function onGatherLiquid(evt:GatherLiquidEvent)
	{
		var candidates = getInventoryCandidates(evt.gatherer);
		var s = new EntitySelectScreen(candidates);
		s.title = 'Choose a container to gather into';
		s.onSelect = (e) ->
		{
			pourInto(e, volume);
			Game.instance.screens.pop();
		};
		Game.instance.screens.push(s);
	}

	private function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (isEmpty)
		{
			return;
		}

		if (isPourable)
		{
			evt.interactions.push({
				name: 'Pour',
				evt: new PourEvent(evt.interactor),
			});
		}

		if (isGatherable)
		{
			evt.interactions.push({
				name: 'Gather',
				evt: new GatherLiquidEvent(evt.interactor),
			});
		}
	}

	private function checkDestroyOnEmpty()
	{
		if (destroyOnEmpty && isEmpty && !entity.has(IsDestroyed))
		{
			entity.add(new IsDestroyed());
		}
	}

	public function applyColorOverrides()
	{
		if (entity.drawable == null)
		{
			return;
		}

		if (overridePrimary)
		{
			if (isEmpty)
			{
				entity.drawable.primaryOverride = null;
			}
			else
			{
				entity.drawable.primaryOverride = liquid.primaryColor;
			}
		}

		if (overrideSecondary)
		{
			if (isEmpty)
			{
				entity.drawable.secondaryOverride = null;
			}
			else
			{
				entity.drawable.secondaryOverride = liquid.secondaryColor;
			}
		}
	}

	private function onEntityLoaded(evt:EntityLoadedEvent)
	{
		applyColorOverrides();
	}

	private function onEntitySpawned(evt:EntitySpawnedEvent)
	{
		applyColorOverrides();
	}

	public function getInventoryCandidates(e:Entity):Array<Entity>
	{
		var inventory = e.get(Inventory);

		if (inventory == null)
		{
			return [];
		}

		return inventory.content.filter((e) ->
		{
			var liquid = e.get(LiquidContainer);
			return liquid != null
				&& liquid != this
				&& liquid.isPourable
				&& (liquid.isEmpty || liquid.liquidType == liquidType)
				&& !liquid.isFull;
		});
	}

	function get_liquid():Liquid
	{
		if (liquidType != null)
		{
			return Liquids.Get(liquidType);
		}
		return null;
	}

	function get_isEmpty():Bool
	{
		return volume <= 0;
	}

	function get_displayName():String
	{
		if (isEmpty)
		{
			return 'empty';
		}

		return '${volume}/${maxVolume} drams of ${liquid.name}';
	}

	function get_remainingVolume():Int
	{
		return maxVolume - volume;
	}

	function get_isFull():Bool
	{
		return volume >= maxVolume;
	}
}
