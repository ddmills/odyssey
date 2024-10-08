package screens.adventure;

import common.algorithm.AStar;
import common.algorithm.Distance;
import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import core.input.KeyCode;
import data.BitmaskType;
import data.Bitmasks;
import data.Cardinal;
import data.TextResources;
import data.TileKey;
import domain.components.BitmaskSprite;
import domain.components.BumpAttack;
import domain.components.Collider;
import domain.components.Door;
import domain.components.Explored;
import domain.components.Health;
import domain.components.IsCreature;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.components.Level;
import domain.components.Move;
import domain.components.Path;
import domain.components.Sprite;
import domain.events.ConsumeEnergyEvent;
import domain.events.MeleeEvent;
import domain.events.OpenDoorEvent;
import domain.prefabs.Spawner;
import domain.systems.EnergySystem;
import domain.terrain.biomes.Biomes;
import h2d.Object;
import h2d.Text;
import screens.ability.AbilityScreen;
import screens.character.CharacterScreen;
import screens.console.ConsoleScreen;
import screens.cursor.LookScreen;
import screens.equipment.EquipmentScreen;
import screens.interaction.InspectScreen;
import screens.inventory.InventoryScreen;
import screens.map.MapScreen;
import screens.save.SaveScreen;
import screens.shooting.BasicShootingScreen;
import screens.skill.SkillScreen;

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
	dbg:Text,
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

		var cfocus = game.camera.focus.toWorld().toFloatPoint();
		var ctarget = world.player.entity.pos.toFloatPoint();

		game.camera.focus = cfocus.lerp(ctarget, .2).asWorld();

		hudText.fps.text = frame.fps.floor().toString();
		hudText.clock.text = world.clock.friendlyString();
		var hp = world.player.entity.get(Health);
		hudText.health.text = '${hp.value}/${hp.max} (${hp.armor}/${hp.armorMax})';

		var mpos = game.input.mouse;
		var zpos = mpos.toZone().toIntPoint();
		var zone = world.zones.getZone(zpos);
		var poi = '';

		if (zone != null && zone.poi != null)
		{
			poi = zone.poi.definition.name;
		}

		hudText.wpos.text = 'world ' + mpos.toWorld().toIntPoint().toString();
		hudText.cpos.text = 'chunk ' + mpos.toChunk().toIntPoint().toString() + ' (${mpos.toChunkIdx()})';
		hudText.zpos.text = 'zone ' + mpos.toZone().toIntPoint().toString() + ' $poi';
		hudText.dbg.text = world.getCurrentBiome().getName();

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
			case KEY_NUM_1: PLAYER_1;
			case KEY_NUM_2: PLAYER_2;
			case KEY_NUM_3: PLAYER_3;
			case KEY_NUM_4: PLAYER_4;
			case KEY_NUM_5: PLAYER_5;
			case _: null;
		}

		if (tk != null)
		{
			var sprite = world.player.entity.get(Sprite);
			sprite.tileKey = tk;
		}

		if (key == KEY_NUM_6)
		{
			var p = game.input.mouse.toWorld().floor();
			Spawner.Spawn(LADDER_UP, p);
			world.systems.vision.computeVision();
		}

		if (key == KEY_NUM_7)
		{
			var p = game.input.mouse.toWorld().floor();
			Spawner.Spawn(LADDER_DOWN, p);
			world.systems.vision.computeVision();
		}

		if (key == KEY_NUM_8)
		{
			var p = game.input.mouse.toWorld().floor();
			Spawner.Spawn(DOG, p);
			world.systems.vision.computeVision();
		}

		if (key == KEY_NUM_9)
		{
			var p = game.input.mouse.toWorld().floor();
			Spawner.Spawn(SCORPION, p);
			world.systems.vision.computeVision();
		}

		if (key == KEY_NUM_0)
		{
			var p = game.input.mouse.toWorld().floor();
			Spawner.Spawn(STONE_WALL, p);
			world.systems.vision.computeVision();
		}
	}

	function handle(command:Command)
	{
		switch (command.type)
		{
			case CMD_SCANLINES:
				game.layers.toggleScanlines();
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
			case CMD_SKILLS:
				game.screens.push(new SkillScreen(world.player.entity));
			case CMD_ABILITIES:
				game.screens.push(new AbilityScreen(world.player.entity));
			case CMD_MAP:
				game.screens.push(new MapScreen());
			case CMD_SHOOT:
				game.screens.push(new BasicShootingScreen(world.player.entity));
			case CMD_SAVE:
				game.screens.push(new SaveScreen(true));
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

		var collider = entities.find((e) -> e.has(Collider) && !e.has(IsInventoried));

		if (collider != null)
		{
			if (collider.has(Door))
			{
				collider.fireEvent(new OpenDoorEvent(world.player.entity));
			}
			return;
		}

		var enemy = entities.find((e) -> e.has(IsCreature));

		if (enemy != null)
		{
			var isHostile = world.factions.areEntitiesHostile(enemy, world.player.entity);
			if (isHostile)
			{
				world.player.entity.fireEvent(new MeleeEvent(enemy, world.player.entity));
				world.player.entity.add(new BumpAttack(dir));
				return;
			}
			else
			{
				enemy.add(new Move(world.player.pos, .1, EASE_LINEAR));
				var eMove = EnergySystem.GetEnergyCost(enemy, ACT_SWAPPED);
				enemy.fireEvent(new ConsumeEnergyEvent(eMove));
			}
		}

		world.player.entity.add(new Move(target.asWorld(), .1, EASE_LINEAR));

		var cost = EnergySystem.GetEnergyCost(world.player.entity, ACT_MOVE);
		world.player.entity.fireEvent(new ConsumeEnergyEvent(cost));
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

		var dbg = new Text(TextResources.BIZCAT, ob);
		dbg.color = game.TEXT_COLOR.toHxdColor();
		dbg.y = 112;

		hudText = {
			ob: ob,
			fps: fps,
			clock: clock,
			health: health,
			wpos: wpos,
			cpos: cpos,
			zpos: zpos,
			xp: xp,
			dbg: dbg,
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

				if (entities.exists((e) -> e.has(Collider) || e.has(IsCreature)))
				{
					return Math.POSITIVE_INFINITY;
				}

				var cell = world.getCell(b);

				if (cell != null && cell.terrain == TERRAIN_WATER)
				{
					return 1000;
				}

				return Distance.Diagonal(a, b);
			}
		});
	}
}
