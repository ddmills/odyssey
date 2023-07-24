package domain.components;

import core.Game;
import data.AudioKey;
import data.ColorKey;
import data.SpawnableType;
import domain.events.HarvestEvent;
import domain.events.QueryInteractionsEvent;
import domain.prefabs.Spawner;
import domain.skills.Skills;
import ecs.Component;

class Harvestable extends Component
{
	@save public var harvestPrefab:SpawnableType;
	@save public var harvestAudio:AudioKey;
	@save public var primaryReplace:Null<ColorKey>;
	@save public var secondaryReplace:Null<ColorKey>;

	public function new(harvestPrefab:SpawnableType, harvestAudio:AudioKey = null, primaryReplace:Null<ColorKey> = null,
			secondaryReplace:Null<ColorKey> = null)
	{
		this.harvestPrefab = harvestPrefab;
		this.primaryReplace = primaryReplace;
		this.secondaryReplace = secondaryReplace;
		this.harvestAudio = harvestAudio;
		addHandler(QueryInteractionsEvent, onQueryInteractions);
		addHandler(HarvestEvent, onHarvestEvent);
	}

	private function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		evt.add({
			name: 'Harvest',
			evt: new HarvestEvent(evt.interactor),
		});
	}

	private function onHarvestEvent(evt:HarvestEvent)
	{
		var amount = Skills.GetValue(SKILL_FORAGE, evt.harvester);
		var result = Spawner.Spawn(harvestPrefab, evt.harvester.pos, {quantity: amount});
		evt.harvester.get(Inventory).addLoot(result);

		Game.instance.world.playAudio(entity.pos.toIntPoint(), harvestAudio);

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
