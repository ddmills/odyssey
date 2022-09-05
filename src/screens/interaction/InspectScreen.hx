package screens.interaction;

import common.struct.Coordinate;
import common.struct.IntPoint;
import common.util.Timeout;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.Cardinal;
import data.TileResources;
import domain.components.IsInventoried;
import domain.components.IsPlayer;
import domain.components.Moniker;
import domain.events.QueryInteractionsEvent;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Object;
import screens.entitySelect.EntitySelectScreen;
import screens.listSelect.ListSelectScreen;
import shaders.SpriteShader;

typedef TargetIndicator =
{
	pos:IntPoint,
	ob:Bitmap,
	shader:SpriteShader,
	isBlinking:Bool,
}

class InspectScreen extends Screen
{
	var ob:Object;
	var interactor:Entity;
	var nearbyInteractables:Array<IntPoint>;
	var indicators:Array<TargetIndicator>;
	var timeout:Timeout;
	var instructionText:h2d.Text;
	var isBlinkActive:Bool;

	public function new(interactor:Entity)
	{
		this.interactor = interactor;
		this.inputDomain = INPUT_DOMAIN_DEFAULT;

		indicators = [];
		ob = new Object();
		isBlinkActive = true;

		instructionText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		instructionText.color = 0xf5f5f5.toHxdColor();
		instructionText.y = 64;
		instructionText.textAlign = Center;

		timeout = new Timeout(.25);
		timeout.onComplete = blink;
	}

	private function blink()
	{
		timeout.reset();
		isBlinkActive = !isBlinkActive;
		indicators.each((b) ->
		{
			if (b.isBlinking)
			{
				b.ob.visible = isBlinkActive;
			}
			else
			{
				b.ob.visible = true;
			}
		});
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
			instructionText.text = 'There is nothing nearby to interact with';
		}
		else if (nearbyInteractables.length == 1)
		{
			inspectLocation(interactor.pos.add(nearbyInteractables[0].asWorld()));
		}
		else
		{
			instructionText.text = 'Choose a direction to inspect';
			nearbyInteractables.each((p:IntPoint) ->
			{
				var w = interactor.pos.add(p.asWorld());
				var px = w.toPx();
				var targetBm = new Bitmap(TileResources.CURSOR, ob);
				targetBm.x = px.x;
				targetBm.y = px.y;
				var shader = new SpriteShader(0x6B6B6B);
				shader.isShrouded = 0;
				shader.clearBackground = 0;
				targetBm.addShader(shader);
				ob.addChild(targetBm);
				indicators.push({
					ob: targetBm,
					pos: w.toIntPoint(),
					shader: shader,
					isBlinking: true,
				});
			});
			ob.x = 0;
			ob.y = 0;
			game.render(OVERLAY, ob);
		}

		game.render(HUD, instructionText);
	}

	function tryInteractDirection(dir:IntPoint)
	{
		var target = interactor.pos.add(dir.asWorld());
		inspectLocation(target);
	}

	function hasInteractables(e:Entity):Bool
	{
		if (e.has(IsPlayer) || e.has(IsInventoried))
		{
			return false;
		}
		var evt = new QueryInteractionsEvent(interactor);
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
			game.screens.replace(new InteractionScreen(interactables[0], interactor));
		}
		else
		{
			var selectScreen = new EntitySelectScreen(interactables);
			selectScreen.fetchEntities = () -> world.getEntitiesAt(pos).filter(hasInteractables);
			selectScreen.targetPos = pos;
			selectScreen.onSelect = (e) ->
			{
				game.screens.replace(new InteractionScreen(e, interactor));
			}
			game.screens.replace(selectScreen);
		}

		return true;
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
	}

	public override function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		var p = pos.toWorld().toIntPoint();
		indicators.each((b:TargetIndicator) ->
		{
			if (b.pos.equals(p))
			{
				b.isBlinking = false;
				b.ob.visible = true;
				b.shader.primary = 0xd4d4d4.toHxdColor();
			}
			else
			{
				b.isBlinking = true;
				b.ob.visible = isBlinkActive;
				b.shader.primary = 0x6B6B6B.toHxdColor();
			}
		});
	}

	public override function onMouseDown(pos:Coordinate)
	{
		inspectLocation(pos);
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
