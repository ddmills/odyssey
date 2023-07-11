package domain.components;

import common.algorithm.Bresenham;
import core.Game;
import data.AudioKey;
import data.SpawnableType;
import domain.events.AttackedEvent;
import domain.events.EntityLoadedEvent;
import domain.events.LightFuseEvent;
import domain.events.QueryInteractionsEvent;
import domain.prefabs.Spawner;
import ecs.Component;
import hxd.Rand;

class Explosive extends Component
{
	@save public var fuseTimeTicks:Int = 750;
	@save public var remainingFuseTicks:Int = 750;
	@save public var explodeAudio:AudioKey = EXPLOSION_STONE;
	@save public var igniteAudio:AudioKey = IGNITE_MATCH;
	@save public var radius:Int = 3;
	@save public var damageDie:Int = 20;
	@save public var damageModifier:Int = 40;
	@save public var isFuseLit:Bool = false;
	@save public var explosionSpawnable:SpawnableType = EXPLOSION;
	@save public var fuseLighterEntityId:String;

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

		fuseLighterEntityId = evt.lighter.id;

		var blink = new HitBlink();
		blink.rateSeconds = .8;
		blink.durationSeconds = Math.POSITIVE_INFINITY;
		entity.add(blink);
		Game.instance.world.playAudio(entity.pos.toIntPoint(), igniteAudio, 100);
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
			explode(fuseLighterEntityId);
		}
	}

	private function explode(exploderEntityId:String)
	{
		var circle = Bresenham.getCircle(entity.pos.toIntPoint(), radius, true);
		for (p in circle)
		{
			var pos = p.asWorld();
			Spawner.Spawn(explosionSpawnable, pos, {
				attackerId: exploderEntityId,
			});
			var entities = Game.instance.world.getEntitiesAt(pos);

			var r = Rand.create();

			entities.each((e) ->
			{
				var damage = r.roll(damageDie) + damageModifier;
				e.fireEvent(new AttackedEvent({
					attacker: Game.instance.registry.getEntity(exploderEntityId),
					toHit: 100,
					damage: damage,
					isCritical: true,
				}));
			});
		}

		Game.instance.world.playAudio(entity.pos.toIntPoint(), explodeAudio, 100);
		entity.add(new IsDestroyed());
	}

	private function onEntityLoaded(evt:EntityLoadedEvent)
	{
		onTickDelta(evt.tickDelta);
	}
}
