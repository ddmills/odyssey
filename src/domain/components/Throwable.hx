package domain.components;

import common.struct.Coordinate;
import core.Game;
import domain.events.ConsumeEnergyEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.ThrowEvent;
import domain.systems.EnergySystem;
import ecs.Component;
import ecs.Entity;
import ecs.Query;
import screens.target.TargetScreen;
import screens.target.footprints.CircleFootprint;

class Throwable extends Component
{
	public function new()
	{
		addHandler(QueryInteractionsEvent, onQueryInteractions);
		addHandler(ThrowEvent, onThrow);
	}

	public function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		evt.add({
			name: 'Throw',
			popScreen: true,
			evt: new ThrowEvent(evt.interactor),
		});
	}

	public function onThrow(evt:ThrowEvent)
	{
		Game.instance.screens.push(new TargetScreen(evt.thrower, {
			origin: CURSOR,
			footprint: new CircleFootprint(2),
			showFootprint: true,
			targetQuery: new Query({
				all: [Visible, Health, IsEnemy],
				none: [IsInventoried, IsDestroyed],
			}),
			onConfirm: (target) ->
			{
				throwAt(evt.thrower, target.cursor.asWorld());
				Game.instance.screens.pop();
			},
			onCancel: () -> Game.instance.screens.pop(),
		}));
	}

	public function throwAt(thrower:Entity, targetPos:Coordinate)
	{
		var thing = entity;

		if (entity.has(IsInventoried))
		{
			var loot = entity.get(Loot);
			thing = loot.removeFromInventory(targetPos, 1);
		}

		thing.pos = targetPos;

		var cost = EnergySystem.GetEnergyCost(thrower, ACT_THROW);
		thrower.fireEvent(new ConsumeEnergyEvent(cost));
	}
}
