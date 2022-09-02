package screens.interaction;

import common.struct.Coordinate;
import common.struct.IntPoint;
import common.util.Timeout;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.Cardinal;
import data.TileResources;
import domain.components.IsPlayer;
import domain.events.GetInteractionsEvent;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Object;
import screens.entitySelect.EntitySelectScreen;
import screens.listSelect.ListSelectScreen;
import shaders.SpriteShader;

class InteractionScreen extends Screen
{
	var ob:Object;
	var interactor:Entity;
	var nearbyInteractables:Array<IntPoint>;
	var interactShader:SpriteShader;
	var timeout:Timeout;
	var instructionText:h2d.Text;

	public function new(interactor:Entity)
	{
		this.interactor = interactor;
		this.inputDomain = INPUT_DOMAIN_DEFAULT;

		ob = new Object();

		instructionText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		instructionText.color = 0xf5f5f5.toHxdColor();
		instructionText.y = 64;
		instructionText.textAlign = Center;

		interactShader = new SpriteShader(0x89a886);
		interactShader.isShrouded = 0;
		interactShader.clearBackground = 0;

		timeout = new Timeout(.25);
		timeout.onComplete = blink;
	}

	private function blink()
	{
		timeout.reset();
		ob.visible = !ob.visible;
	}

	override function onEnter()
	{
		ob.removeChildren();
		var offsets = Cardinal.values.map((c) -> c.toOffset());
		offsets.push({x: 0, y: 0});

		nearbyInteractables = offsets.filter((pos) ->
		{
			var w = interactor.pos.add(pos.asWorld());
			return world
				.getEntitiesAt(w)
				.filter(hasInteractables).length > 0;
		});

		if (nearbyInteractables.length == 0)
		{
			game.screens.pop();
			return;
		}

		if (nearbyInteractables.length == 1)
		{
			inspectLocation(interactor.pos.add(nearbyInteractables[0].asWorld()));
		}
		else
		{
			instructionText.text = 'Choose a direction to inspect';
			nearbyInteractables.each((p:IntPoint) ->
			{
				var px = interactor.pos.add(p.asWorld()).toPx();
				var targetBm = new Bitmap(TileResources.CURSOR, ob);
				targetBm.x = px.x;
				targetBm.y = px.y;
				targetBm.addShader(interactShader);
				ob.addChild(targetBm);
			});
			ob.x = 0;
			ob.y = 0;
			game.render(OVERLAY, ob);
			game.render(HUD, instructionText);
		}
	}

	function tryInteractDirection(dir:IntPoint)
	{
		var target = interactor.pos.add(dir.asWorld());
		inspectLocation(target);
	}

	function hasInteractables(e:Entity):Bool
	{
		if (e.has(IsPlayer))
		{
			return false;
		}
		var evt = new GetInteractionsEvent(interactor);
		e.fireEvent(evt);

		return evt.interactions.length > 0;
	}

	function inspectLocation(pos:Coordinate):Bool
	{
		var interactables = world.getEntitiesAt(pos).filter(hasInteractables);

		if (interactables.length <= 0)
		{
			return false;
		}

		if (interactables.length == 1)
		{
			var s = getShowInteractions(interactables[0]);
			game.screens.replace(s);
		}
		else
		{
			var selectScreen = new EntitySelectScreen(interactables);
			selectScreen.onSelect = (e) ->
			{
				game.screens.replace(getShowInteractions(e));
			}
			game.screens.replace(selectScreen);
		}

		return true;
	}

	function getShowInteractions(entity:Entity):Screen
	{
		var evt = new GetInteractionsEvent(interactor);
		entity.fireEvent(evt);

		var items = evt.interactions.map((action) -> ({
			title: action.name,
			onSelect: () ->
			{
				entity.fireEvent(action.evt);
				game.screens.pop();
			},
			getIcon: () -> null,
		}));

		return new ListSelectScreen(items);
	}

	override function update(frame:Frame)
	{
		handle(game.commands.next());
		timeout.update();
		instructionText.x = game.window.width / 2;
	}

	override function onDestroy()
	{
		ob.remove();
		instructionText.remove();
	}

	override function onResume()
	{
		ob.visible = true;
		timeout.reset();
	}

	override function onSuspend()
	{
		ob.visible = false;
		// in
	}

	function handle(command:Command)
	{
		if (command == null)
		{
			return;
		}

		switch (command.type)
		{
			case CMD_WAIT:
				tryInteractDirection({x: 0, y: 0});
			case CMD_MOVE_NW:
				tryInteractDirection(NORTH_WEST.toOffset());
			case CMD_MOVE_N:
				tryInteractDirection(NORTH.toOffset());
			case CMD_MOVE_NE:
				tryInteractDirection(NORTH_EAST.toOffset());
			case CMD_MOVE_E:
				tryInteractDirection(EAST.toOffset());
			case CMD_MOVE_W:
				tryInteractDirection(WEST.toOffset());
			case CMD_MOVE_SW:
				tryInteractDirection(SOUTH_WEST.toOffset());
			case CMD_MOVE_S:
				tryInteractDirection(SOUTH.toOffset());
			case CMD_MOVE_SE:
				tryInteractDirection(SOUTH_EAST.toOffset());
			case CMD_CANCEL:
				game.screens.pop();
			case _:
		}
	}
}
