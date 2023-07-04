package screens.shooting;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.Cardinal;
import data.ColorKey;
import data.TextResources;
import data.TileResources;
import domain.GameMath;
import domain.components.EquipmentSlot;
import domain.components.Health;
import domain.components.Highlight;
import domain.components.IsDestroyed;
import domain.components.IsEnemy;
import domain.components.IsInventoried;
import domain.components.Visible;
import domain.components.Weapon;
import domain.events.ReloadEvent;
import domain.events.ShootEvent;
import domain.weapons.Weapons;
import ecs.Entity;
import ecs.Query;
import h2d.Anim;
import h2d.Text;
import screens.console.ConsoleScreen;
import shaders.SpriteShader;

class ShootingScreen extends Screen
{
	var shooter:Entity;
	var hud:h2d.Object;
	var ob:h2d.Object;
	var targetBm:Anim;
	var targetShader:SpriteShader;
	var weapon(get, never):Weapon;
	var hitChanceTxt:Text;

	var query:Query;
	var highlights:Query;

	var targets:Array<Entity>;
	var targetIdx:Int = 0;
	var targetPos:Coordinate;
	var target(get, never):Null<Entity>;
	var NORTH_WEST(default, null):Dynamic;

	function get_target():Null<Entity>
	{
		return targets[targetIdx];
	}

	public function new(shooter:Entity)
	{
		this.shooter = shooter;

		inputDomain = INPUT_DOMAIN_ADVENTURE;
		targets = new Array();

		targetShader = new SpriteShader(ColorKey.C_WHITE_1);
		targetShader.isShrouded = 0;
		targetShader.clearBackground = 0;
		ob = new h2d.Object();
		hud = new h2d.Object();
		targetBm = new Anim([
			TileResources.Get(CURSOR_SPIN_1),
			TileResources.Get(CURSOR_SPIN_2),
			TileResources.Get(CURSOR_SPIN_3),
			TileResources.Get(CURSOR_SPIN_4),
			TileResources.Get(CURSOR_SPIN_5),
		], 10, ob);
		targetBm.addShader(targetShader);

		hitChanceTxt = new Text(TextResources.BIZCAT);
		hitChanceTxt.color = ColorKey.C_WHITE_1.toHxdColor();
		hitChanceTxt.x = 16;
		hitChanceTxt.y = 16;

		hud.addChild(hitChanceTxt);

		query = new Query({
			all: [Visible, Health, IsEnemy],
			none: [IsInventoried, IsDestroyed],
		});
		highlights = new Query({
			all: [Highlight],
		});
	}

	override function onEnter()
	{
		super.onEnter();
		game.render(HUD, hud);
		game.render(OVERLAY, ob);
		targetIdx = 0;
		targetPos = world.player.pos.floor();
		targets = new Array();
	}

	public override function update(frame:Frame)
	{
		if (target != null)
		{
			targetPos = target.pos;
		}

		highlights.each((e:Entity) ->
		{
			if (!query.has(e))
			{
				e.remove(Highlight);
			}
		});

		query.each((t:Entity, idx:Int) ->
		{
			var highlight = t.get(Highlight);
			if (highlight == null)
			{
				highlight = new Highlight();
				t.add(highlight);
			}

			if (targetPos.equals(t.pos))
			{
				targetIdx = idx;
			}

			if (idx == targetIdx)
			{
				highlight.showArrow = true;
				highlight.showRing = false;
				highlight.color = ColorKey.C_YELLOW_1;
			}
			else
			{
				highlight.showArrow = false;
				highlight.showRing = true;
				highlight.color = ColorKey.C_WHITE_1;
			}
		});

		if (world.systems.energy.isPlayersTurn)
		{
			var cmd = game.commands.peek();
			if (cmd != null)
			{
				handleInput(game.commands.next());
			}
		}
		world.updateSystems();

		targets = query.toArray();

		var targetPosPx = targetPos.toPx();
		targetBm.setPosition(targetPosPx.x, targetPosPx.y);

		if (target != null && weapon != null)
		{
			var health = target.get(Health).toString();
			var chance = (GameMath.GetHitChance(shooter, target, weapon, true) * 100).round();
			var dist = GameMath.GetTargetDistance(shooter.pos.toIntPoint(), target.pos.toIntPoint());
			var mod = GameMath.GetRangePenalty(shooter.pos.toIntPoint(), target.pos.toIntPoint(), weapon.range);
			hitChanceTxt.text = '$targetIdx -- $chance% ($dist/$mod) $health';
			hitChanceTxt.visible = true;
			var highlight = target.get(Highlight);
			if (highlight != null)
			{
				highlight.color = ColorKey.C_YELLOW_1;
				highlight.showArrow = true;
			}
		}
		else
		{
			hitChanceTxt.visible = false;
		}

		var targetPosPx = targetPos.toPx();
		targetBm.x = targetPosPx.x;
		targetBm.y = targetPosPx.y;
		targetBm.visible = targetIdx < 0;
	}

	override function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		var prevWorld = previous.toWorld().floor();
		var curWorld = pos.toWorld().floor();

		if (!curWorld.equals(prevWorld))
		{
			targetPos = curWorld;
			targetIdx = -1;
		}
	}

	function handleInput(command:Command)
	{
		switch (command.type)
		{
			case CMD_MOVE_NW:
				look(NORTH_WEST);
			case CMD_MOVE_N:
				look(NORTH);
			case CMD_MOVE_NE:
				look(NORTH_EAST);
			case CMD_MOVE_E:
				look(EAST);
			case CMD_MOVE_W:
				look(WEST);
			case CMD_MOVE_SW:
				look(SOUTH_WEST);
			case CMD_MOVE_S:
				look(SOUTH);
			case CMD_MOVE_SE:
				look(SOUTH_EAST);
			case CMD_LOOK:
				game.screens.pop();
			case CMD_CANCEL:
				game.screens.pop();
			case CMD_CONSOLE:
				game.screens.push(new ConsoleScreen());
			case CMD_CYCLE_INPUT:
				targetIdx = (targetIdx + 1) % targets.length;
			case CMD_SHOOT:
				tryShoot();
			case CMD_RELOAD:
				tryReload();
			case _:
		}
	}

	override function onMouseDown(pos:Coordinate)
	{
		game.commands.push({
			domain: INPUT_DOMAIN_ADVENTURE,
			type: CMD_SHOOT,
			key: KEY_F,
			shift: false,
			ctrl: false,
			alt: false,
		});
	}

	function tryShoot()
	{
		if (weapon == null)
		{
			return;
		}

		weapon.entity.fireEvent(new ShootEvent(targetPos.toWorld().toIntPoint(), shooter));
	}

	function tryReload()
	{
		if (weapon == null)
		{
			return;
		}

		weapon.entity.fireEvent(new ReloadEvent(shooter));
	}

	public override function onDestroy()
	{
		ob.remove();
		hud.remove();
		var highlights = new Query({
			all: [Highlight],
		});

		highlights.each((entity:Entity) ->
		{
			entity.remove(Highlight);
		});

		targetIdx = 0;
		targets = new Array();
	}

	private function look(dir:Cardinal)
	{
		targetPos = targetPos.add(dir.toOffset().asWorld());
	}

	function get_weapon():Weapon
	{
		var weapons = shooter.getAll(EquipmentSlot).filter((s) ->
		{
			if (s.isEmpty || s.isExtraSlot || !s.isPrimary)
			{
				return false;
			}

			var wpn = s.content.get(Weapon);

			if (wpn == null)
			{
				return false;
			}

			return Weapons.Get(wpn.family).isRanged;
		}).map((s) -> s.content.get(Weapon));

		return weapons.first();
	}
}
