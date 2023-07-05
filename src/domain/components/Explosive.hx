package domain.components;

import common.algorithm.Bresenham;
import core.Game;
import data.AudioKey;
import data.SpawnableType;
import domain.events.EntityLoadedEvent;
import domain.events.LightFuseEvent;
import domain.events.QueryInteractionsEvent;
import domain.prefabs.Spawner;
import ecs.Component;

class Explosive extends Component
{
	@save public var fuseTimeTicks:Int = 750;
	@save public var remainingFuseTicks:Int = 750;
	@save public var explodeAudio:AudioKey = EXPLOSION_STONE;
	@save public var radius:Int = 3;
	@save public var isFuseLit:Bool = false;
	@save public var explosionSpawnable:SpawnableType = EXPLOSION;

	public function new()
	{
		addHandler(QueryInteractionsEvent, onQueryInteractions);
		addHandler(LightFuseEvent, onLightFuse);
		addHandler(EntityLoadedEvent, onEntityLoaded);
	}

	public function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (!isFuseLit)
		{
			evt.add({
				name: "Light fuse",
				evt: new LightFuseEvent(evt.interactor),
			});
		}
	}

	public function onLightFuse(evt:LightFuseEvent)
	{
		var stackable = entity.get(Stackable);

		if (stackable != null)
		{
			stackable.shaveStackable();
		}

		var blink = new HitBlink();
		blink.rateSeconds = .8;
		blink.durationSeconds = Math.POSITIVE_INFINITY;
		entity.add(blink);
		isFuseLit = true;
		remainingFuseTicks = fuseTimeTicks;
	}

	public function onTickDelta(tickDelta:Int)
	{
		if (isFuseLit)
		{
			remainingFuseTicks -= tickDelta;
		}

		var blink = entity.get(HitBlink);
		if (blink != null)
		{
			blink.rateSeconds = .05.lerp(.5, remainingFuseTicks / fuseTimeTicks);
		}

		if (remainingFuseTicks <= 0)
		{
			var circle = Bresenham.getCircle(entity.pos.toIntPoint(), radius, true);
			for (p in circle)
			{
				var pos = p.asWorld();
				Spawner.Spawn(explosionSpawnable, pos);
			}

			Game.instance.world.playAudio(entity.pos.toIntPoint(), explodeAudio, 100);
			entity.add(new IsDestroyed());
		}
	}

	private function onEntityLoaded(evt:EntityLoadedEvent)
	{
		onTickDelta(evt.tickDelta);
	}
}
