package screens.inventory;

import core.Game;
import domain.components.LiquidContainer;
import ecs.Entity;
import screens.entitySelect.EntitySelectScreen;
import screens.listSelect.ListSelectScreen;
import screens.prompt.NumberPromptScreen;

class LiquidPourScreen extends ListSelectScreen
{
	private var liquid:LiquidContainer;
	private var pourer:Entity;

	public function new(liquid:LiquidContainer, pourer:Entity)
	{
		this.liquid = liquid;
		this.pourer = pourer;

		var items = [
			{
				title: 'On ground',
				onSelect: pourOnGround,
			},
			{
				title: 'Into container',
				onSelect: pourIntoOther,
			},
			{
				title: 'Into nearby container',
				onSelect: pourIntoNearby,
			},
			{
				title: 'On self',
				onSelect: pourOnSelf,
			},
		];

		super(items);
		title = 'Pour where?';
	}

	private function pourOnGround()
	{
		showSelectVolumeScreen((volume) ->
		{
			liquid.pour(pourer.pos, volume);
			game.screens.pop();
		});
	}

	private function pourOnSelf()
	{
		trace('pourOnSelf');
		game.screens.pop();
	}

	private function pourIntoNearby()
	{
		trace('pourIntoNearby');
		game.screens.pop();
	}

	private function pourIntoOther()
	{
		trace('pourIntoOther');
		game.screens.pop();
		var candidates = liquid.getInventoryCandidates(pourer);
		var s = new EntitySelectScreen(candidates);
		s.title = 'Choose a container to pour into';
		s.onSelect = (e) ->
		{
			Game.instance.screens.pop();
			showSelectVolumeScreen((volume) ->
			{
				liquid.pourInto(e, volume);
				Game.instance.screens.pop();
			});
		};
		Game.instance.screens.push(s);
	}

	private function showSelectVolumeScreen(onVolumePicked:(volume:Int) -> Void)
	{
		var s = new NumberPromptScreen();

		s.title = 'How much to pour? (${liquid.volume} drams total)';
		s.max = liquid.volume;
		s.setValue(liquid.volume);
		s.onAccept = (v) ->
		{
			if (s.value > 0)
			{
				onVolumePicked(s.value);
			}
			Game.instance.screens.pop();
		};
		Game.instance.screens.push(s);
	}
}
