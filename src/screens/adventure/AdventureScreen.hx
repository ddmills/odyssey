package screens.adventure;

import common.algorithm.AStar;
import common.algorithm.Distance;
import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import core.input.KeyCode;
import data.Cardinal;
import data.TextResources;
import data.TileKey;
import domain.components.Collider;
import domain.components.Health;
import domain.components.IsEnemy;
import domain.components.IsInventoried;
import domain.components.Level;
import domain.components.Move;
import domain.components.Sprite;
import domain.events.MeleeEvent;
import domain.prefabs.Spawner;
import domain.systems.EnergySystem;
import h2d.Object;
import h2d.Text;
import screens.character.CharacterScreen;
import screens.console.ConsoleScreen;
import screens.cursor.LookScreen;
import screens.equipment.EquipmentScreen;
import screens.interaction.InspectScreen;
import screens.inventory.InventoryScreen;
import screens.map.MapScreen;
import screens.save.SaveScreen;
import screens.shooting.ShootingScreen;

typedef HudText =
{
	ob:Object,
	fps:Text,
	clock:Text,
	health:Text,
	wpos:Text,
	cpos:Text,
	zpos:Text,
	xp:Text,
}

class AdventureScreen extends Screen
{
	var hudText:HudText;

	public function new()
	{
		inputDomain = INPUT_DOMAIN_ADVENTURE;
	}

	public override function onEnter()
	{
		renderText();
		world.systems.vision.computeVision();
		trace(world.mapWidth * world.mapHeight);
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
		hudText.fps.text = frame.fps.floor().toString();
		hudText.clock.text = world.clock.friendlyString();
		var hp = world.player.entity.get(Health);
		hudText.health.text = '${hp.value}/${hp.max}';

		var mpos = game.input.mouse;
		hudText.wpos.text = 'world ' + mpos.toWorld().toIntPoint().toString();
		hudText.cpos.text = 'chunk ' + mpos.toChunk().toIntPoint().toString() + '(${mpos.toChunkIdx()})';
		hudText.zpos.text = 'zone ' + mpos.toZone().toIntPoint().toString() + '(${mpos.toZoneIdx()})';

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

	override function onKeyDown(key:KeyCode)
	{
		var tk:TileKey = switch key
		{
			case KEY_NUM_1: PERSON_1;
			case KEY_NUM_2: PERSON_2;
			case KEY_NUM_3: PERSON_3;
			case KEY_NUM_4: PERSON_4;
			case KEY_NUM_5: PERSON_5;
			case KEY_NUM_6: PERSON_6;
			case KEY_NUM_7: PERSON_7;
			case KEY_NUM_8: PERSON_8;
			case KEY_NUM_9: PERSON_9;
			case KEY_NUM_0: PERSON_10;
			case _: null;
		}

		if (tk != null)
		{
			var sprite = world.player.entity.get(Sprite);
			sprite.tileKey = tk;
		}

		if (key == KEY_NUM_0)
		{
			var p = game.input.mouse.toWorld().floor();
			Spawner.Spawn(WOOD_WALL_WINDOW, p);
			world.systems.vision.computeVision();
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
				EnergySystem.ConsumeEnergy(world.player.entity, ACT_WAIT);
			case CMD_CONSOLE:
				game.screens.push(new ConsoleScreen());
			case CMD_LOOK:
				game.screens.push(new LookScreen());
			case CMD_INTERACT:
				onInteract(world.player.pos);
			case CMD_INVENTORY:
				game.screens.push(new InventoryScreen(world.player.entity, world.player.entity));
			case CMD_EQUIPMENT:
				game.screens.push(new EquipmentScreen(world.player.entity));
			case CMD_CHARACTER:
				game.screens.push(new CharacterScreen(world.player.entity));
			case CMD_MAP:
				game.screens.push(new MapScreen());
			case CMD_SHOOT:
				game.screens.push(new ShootingScreen(world.player.entity));
			case CMD_SAVE:
				game.screens.push(new SaveScreen(true));
			case _:
		}
	}

	override function onMouseDown(pos:Coordinate)
	{
		// var p = astar(pos);
		// if (p.success)
		// {
		// 	world.player.entity.remove(Path);
		// 	world.player.entity.add(new Path(p.path));
		// }

		Spawner.Spawn(WOOD_WALL, pos.toWorld().floor());
		world.systems.vision.computeVision();
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

		if (entities.exists((e) -> e.has(Collider) && !e.has(IsInventoried)))
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

		var fps = new Text(TextResources.BIZCAT, ob);
		fps.color = game.TEXT_COLOR_FOCUS.toHxdColor();
		fps.y = 0;

		var clock = new Text(TextResources.BIZCAT, ob);
		clock.color = game.TEXT_COLOR.toHxdColor();
		clock.y = 16;

		var health = new Text(TextResources.BIZCAT, ob);
		health.color = game.TEXT_COLOR.toHxdColor();
		health.y = 32;

		var wpos = new Text(TextResources.BIZCAT, ob);
		wpos.color = game.TEXT_COLOR.toHxdColor();
		wpos.y = 48;

		var cpos = new Text(TextResources.BIZCAT, ob);
		cpos.color = game.TEXT_COLOR.toHxdColor();
		cpos.y = 64;

		var zpos = new Text(TextResources.BIZCAT, ob);
		zpos.color = game.TEXT_COLOR.toHxdColor();
		zpos.y = 80;

		var xp = new Text(TextResources.BIZCAT, ob);
		xp.color = game.TEXT_COLOR.toHxdColor();
		xp.y = 96;

		hudText = {
			ob: ob,
			fps: fps,
			clock: clock,
			health: health,
			wpos: wpos,
			cpos: cpos,
			zpos: zpos,
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
				if (world.isOutOfBounds(b))
				{
					return Math.POSITIVE_INFINITY;
				}

				var entities = world.getEntitiesAt(b);

				if (entities.exists((e) -> e.has(Collider) || e.has(IsEnemy)))
				{
					return Math.POSITIVE_INFINITY;
				}

				return Distance.Diagonal(a, b);
			}
		});
	}
}
