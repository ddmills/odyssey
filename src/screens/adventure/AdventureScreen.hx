package screens.adventure;

import common.algorithm.AStar;
import common.algorithm.Distance;
import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.Cardinal;
import data.TextResources;
import domain.GameMath;
import domain.components.Blocker;
import domain.components.Health;
import domain.components.IsEnemy;
import domain.components.IsInventoried;
import domain.components.Level;
import domain.components.Move;
import domain.components.Path;
import domain.events.ConsumeEnergyEvent;
import domain.events.MeleeEvent;
import domain.systems.EnergySystem;
import h2d.Object;
import h2d.Text;
import screens.character.CharacterScreen;
import screens.console.ConsoleScreen;
import screens.cursor.LookScreen;
import screens.equipment.EquipmentScreen;
import screens.interaction.InspectScreen;
import screens.inventory.InventoryScreen;
import screens.shooting.ShootingScreen;

typedef HudText =
{
	ob:Object,
	clock:Text,
	health:Text,
	wpos:Text,
	cpos:Text,
	xp:Text,
}

class AdventureScreen extends Screen
{
	var hudText:HudText;

	public function new()
	{
		inputDomain = INPUT_DOMAIN_ADVENTURE;
		trace(GameMath.GetXpGain(2, 3));
		trace(GameMath.GetXpGain(4, 1));
	}

	public override function onEnter()
	{
		renderText();
	}

	public override function onSuspend()
	{
		hudText.ob.visible = false;
	}

	public override function onResume()
	{
		hudText.ob.visible = true;
	}

	public override function update(frame:Frame)
	{
		world.updateSystems();
		game.camera.focus = world.player.pos;
		hudText.clock.text = world.clock.toString();
		var hp = world.player.entity.get(Health);
		hudText.health.text = '${hp.value}/${hp.max}';

		var mpos = game.input.mouse;
		hudText.wpos.text = mpos.toWorld().toIntPoint().toString();
		hudText.cpos.text = mpos.toChunk().toIntPoint().toString() + '(${mpos.toChunkIdx()})';

		var lvl = world.player.entity.get(Level);
		hudText.xp.text = 'Level ${lvl.level} ${lvl.xp}/${lvl.nextLevelXpReq}';

		if (world.systems.energy.isPlayersTurn)
		{
			var cmd = game.commands.peek();
			if (cmd != null)
			{
				if (world.player.entity.has(Move))
				{
					world.systems.movement.finishMoveFast(world.player.entity);
				}
				else
				{
					handle(game.commands.next());
				}
			}
		}
	}

	function handle(command:Command)
	{
		switch (command.type)
		{
			case CMD_MOVE_NW:
				move(NORTH_WEST);
			case CMD_MOVE_N:
				move(NORTH);
			case CMD_MOVE_NE:
				move(NORTH_EAST);
			case CMD_MOVE_E:
				move(EAST);
			case CMD_MOVE_W:
				move(WEST);
			case CMD_MOVE_SW:
				move(SOUTH_WEST);
			case CMD_MOVE_S:
				move(SOUTH);
			case CMD_MOVE_SE:
				move(SOUTH_EAST);
			case CMD_WAIT:
				var cost = EnergySystem.getEnergyCost(world.player.entity, ACT_WAIT);
				world.player.entity.fireEvent(new ConsumeEnergyEvent(cost));
			case CMD_CONSOLE:
				game.screens.push(new ConsoleScreen());
			case CMD_LOOK:
				game.screens.push(new LookScreen());
			case CMD_CONFIRM:
				onInteract(world.player.pos);
			case CMD_INVENTORY:
				game.screens.push(new InventoryScreen(world.player.entity, world.player.entity));
			case CMD_EQUIPMENT:
				game.screens.push(new EquipmentScreen(world.player.entity));
			case CMD_CHARACTER:
				game.screens.push(new CharacterScreen(world.player.entity));
			case CMD_SHOOT:
				game.screens.push(new ShootingScreen(world.player.entity));
			case _:
		}
	}

	override function onMouseDown(pos:Coordinate)
	{
		var p = astar(pos);
		if (p.success)
		{
			world.player.entity.remove(Path);
			world.player.entity.add(new Path(p.path));
		}
	}

	private function move(dir:Cardinal)
	{
		var target = world.player.pos.toIntPoint().add(dir.toOffset());
		var entities = world.getEntitiesAt(target);
		var enemy = entities.find((e) -> e.has(IsEnemy));

		if (enemy != null)
		{
			world.player.entity.fireEvent(new MeleeEvent(enemy, world.player.entity));
			return;
		}

		if (entities.exists((e) -> e.has(Blocker) && !e.has(IsInventoried)))
		{
			return;
		}

		world.player.entity.add(new Move(target.asWorld(), .15, LINEAR));
	}

	private function onInteract(pos:Coordinate)
	{
		game.screens.push(new InspectScreen(world.player.entity));
	}

	private function renderText()
	{
		var ob = new Object();
		ob.x = 16;
		ob.y = 16;

		var clock = new Text(TextResources.BIZCAT, ob);
		clock.color = 0xf5f5f5.toHxdColor();
		clock.y = 0;

		var health = new Text(TextResources.BIZCAT, ob);
		health.color = 0xf5f5f5.toHxdColor();
		health.y = 16;

		var cpos = new Text(TextResources.BIZCAT, ob);
		cpos.color = 0xf5f5f5.toHxdColor();
		cpos.y = 32;

		var wpos = new Text(TextResources.BIZCAT, ob);
		wpos.color = 0xf5f5f5.toHxdColor();
		wpos.y = 48;

		var xp = new Text(TextResources.BIZCAT, ob);
		xp.color = 0xf5f5f5.toHxdColor();
		xp.y = 64;

		hudText = {
			ob: ob,
			clock: clock,
			health: health,
			cpos: cpos,
			wpos: wpos,
			xp: xp,
		};

		game.render(HUD, ob);
	}

	function astar(goal:Coordinate)
	{
		return AStar.GetPath({
			start: world.player.pos.toWorld().toIntPoint(),
			goal: goal.toWorld().toIntPoint(),
			allowDiagonals: true,
			cost: (a, b) ->
			{
				if (world.map.isOutOfBounds(b.x, b.y))
				{
					return Math.POSITIVE_INFINITY;
				}

				var entities = world.getEntitiesAt(b);

				if (entities.exists((e) -> e.has(Blocker) || e.has(IsEnemy)))
				{
					return Math.POSITIVE_INFINITY;
				}

				return Distance.Diagonal(a, b);
			}
		});
	}
}
