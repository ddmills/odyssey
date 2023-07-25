package domain.components;

import core.Game;
import data.AudioKey;
import data.ColorKey;
import data.SpawnableType;
import domain.events.ForageEvent;
import domain.events.QueryInteractionsEvent;
import domain.prefabs.Spawner;
import domain.skills.Skills;
import ecs.Component;

class Forageable extends Component
{
	@save public var foragePrefab:SpawnableType;
	@save public var forageAudio:AudioKey;
	@save public var primaryReplace:Null<ColorKey>;
	@save public var secondaryReplace:Null<ColorKey>;
	@save public var destroyOnForage:Bool;

	public function new(foragePrefab:SpawnableType, forageAudio:AudioKey = null, destroyOnForage:Bool = false, primaryReplace:Null<ColorKey> = null,
			secondaryReplace:Null<ColorKey> = null)
	{
		this.foragePrefab = foragePrefab;
		this.destroyOnForage = destroyOnForage;
		this.primaryReplace = primaryReplace;
		this.secondaryReplace = secondaryReplace;
		this.forageAudio = forageAudio;

		addHandler(QueryInteractionsEvent, onQueryInteractions);
		addHandler(ForageEvent, onForageEvent);
	}

	private function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		evt.add({
			name: 'Forage',
			evt: new ForageEvent(evt.interactor),
		});
	}

	private function onForageEvent(evt:ForageEvent)
	{
		var amount = Skills.GetValue(SKILL_FORAGE, evt.forager);
		var result = Spawner.Spawn(foragePrefab, evt.forager.pos, {quantity: amount});
		evt.forager.get(Inventory).addLoot(result);

		Game.instance.world.playAudio(entity.pos.toIntPoint(), forageAudio);

		if (primaryReplace != null)
		{
			entity.get(Sprite).primary = primaryReplace;
		}
		if (secondaryReplace != null)
		{
			entity.get(Sprite).secondary = secondaryReplace;
		}

		entity.remove(this);
	}
}
