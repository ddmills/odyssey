package screens.adventure;

import common.algorithm.AStar;
import common.algorithm.Distance;
import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.Cardinal;
import domain.components.Blocker;
import domain.components.Energy;
import domain.components.Health;
import domain.components.IsEnemy;
import domain.components.IsInventoried;
import domain.components.Move;
import domain.components.Path;
import domain.components.Sprite;
import domain.events.MeleeEvent;
import domain.systems.EnergySystem;
import screens.console.ConsoleScreen;
import screens.cursor.LookScreen;
import screens.equipment.EquipmentScreen;
import screens.interaction.InspectScreen;
import screens.inventory.InventoryScreen;
import screens.shooting.ShootingScreen;

class AdventureScreen extends Screen
{
	var clockText:h2d.Text;
	var healthText:h2d.Text;

	public function new()
	{
		inputDomain = INPUT_DOMAIN_ADVENTURE;
	}

	public override function onEnter()
	{
		renderClock();
	}

	public override function update(frame:Frame)
	{
		world.updateSystems();
		game.camera.focus = world.player.pos;
		clockText.text = world.clock.toString() + ' ' + world.player.pos.floor().toString();
		var hp = world.player.entity.get(Health);
		healthText.text = '${hp.value}/${hp.max}';

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
				world.player.entity.get(Energy).consumeEnergy(cost);
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

	private function renderClock()
	{
		clockText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		clockText.setScale(1);
		clockText.text = world.clock.toString();
		clockText.color = 0xf5f5f5.toHxdColor();
		clockText.x = 16;
		clockText.y = 16;

		healthText = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		healthText.setScale(1);
		healthText.text = '';
		healthText.color = 0xf5f5f5.toHxdColor();
		healthText.x = 16;
		healthText.y = 32;

		game.render(HUD, clockText);
		game.render(HUD, healthText);
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