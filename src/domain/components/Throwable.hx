package domain.components;

import common.struct.Coordinate;
import core.Game;
import domain.events.ConsumeEnergyEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.ThrowEvent;
import domain.stats.Stats;
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
		var explosive = entity.get(Explosive);

		var radius = explosive != null ? explosive.radius : 0;
		var throwinStat = Stats.GetValue(STAT_THROWING, evt.thrower);
		var range = GameMath.GetThrowingDistance(throwinStat);

		Game.instance.screens.push(new TargetScreen(evt.thrower, {
			origin: TARGETER,
			footprint: new CircleFootprint(radius),
			showFootprint: true,
			range: range,
			allowOutsideRange: false,
			targetQuery: new Query({
				all: [Visible, Health, IsCreature],
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
			thing = loot.removeFromInventory(thrower.pos, 1);
		}

		thing.pos = thrower.pos;
		thing.add(new Move(targetPos, .75, EASE_IN_QUAD));

		var cost = EnergySystem.GetEnergyCost(thrower, ACT_THROW);
		thrower.fireEvent(new ConsumeEnergyEvent(cost));
	}
}
