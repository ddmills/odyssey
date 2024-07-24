package screens.shooting;

import common.struct.Coordinate;
import core.Frame;
import core.input.Command;
import data.AnimationResources;
import data.Cardinal;
import data.ColorKey;
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
import screens.console.ConsoleScreen;
import screens.target.TargetScreen;
import screens.target.footprints.EmptyFootprint;
import shaders.SpriteShader;

class ShootingScreen extends TargetScreen
{
	var shooter:Entity;
	var targetBm:Anim;
	var targetShader:SpriteShader;
	var weapon(get, never):Weapon;

	var targets:Query;
	var highlights:Query;
	var targetEntityId:Null<String>;
	var target(get, never):Null<Entity>;

	public function new(shooter:Entity)
	{
		this.shooter = shooter;
		inputDomain = INPUT_DOMAIN_ADVENTURE;

		targetShader = new SpriteShader(ColorKey.C_YELLOW_0);
		targetShader.isShrouded = 0;
		targetShader.clearBackground = 0;

		targetBm = new Anim(AnimationResources.Get(CURSOR_SPIN), 10, ob);
		targetBm.addShader(targetShader);

		targets = new Query({
			all: [Visible, Health, IsEnemy],
			none: [IsInventoried, IsDestroyed],
		});
		highlights = new Query({
			all: [Highlight],
		});

		if (weapon != null)
		{
			var footprint = Weapons.Get(weapon.family).getFootprint();
			super(shooter, {
				origin: TARGETER,
				footprint: footprint,
			});
		}
		else
		{
			super(shooter, {
				origin: TARGETER,
				footprint: new EmptyFootprint(),
			});
		}
	}

	override function onEnter()
	{
		super.onEnter();
		targetEntityId = null;
		cursor = shooter.pos.floor();
		var closest = getClosestTarget();
		if (closest != null)
		{
			targetEntityId = closest.id;
		}
	}

	override function update(frame:Frame)
	{
		if (weapon == null)
		{
			game.screens.pop();
		}

		if (target != null)
		{
			cursor = target.pos;
		}

		highlights.each((e:Entity) ->
		{
			if (!targets.has(e))
			{
				e.remove(Highlight);
			}
		});

		targets.each((t:Entity, idx:Int) ->
		{
			var highlight = t.get(Highlight);
			if (highlight == null)
			{
				highlight = new Highlight();
				t.add(highlight);
			}

			if (cursor.equals(t.pos))
			{
				targetEntityId = t.id;
			}

			if (t.id == targetEntityId)
			{
				highlight.showArrow = true;
				highlight.showRing = false;
				highlight.color = ColorKey.C_YELLOW_1;
			}
			else
			{
				highlight.showArrow = false;
				highlight.showRing = true;
				highlight.color = ColorKey.C_YELLOW_0;
			}
		});

		world.updateSystems();
		super.update(frame);

		if (world.systems.energy.isPlayersTurn)
		{
			var cmd = game.commands.peek();
			if (cmd != null)
			{
				handleInput(game.commands.next());
			}
		}

		var targetPosPx = cursor.toPx();
		targetBm.setPosition(targetPosPx.x, targetPosPx.y);
		targetBm.visible = targetEntityId == null;
	}

	override function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		super.onMouseMove(pos, previous);
		var prevWorld = previous.toWorld().floor();
		var curWorld = pos.toWorld().floor();

		if (!curWorld.equals(prevWorld))
		{
			cursor = curWorld;
			targetEntityId = null;
		}
	}

	private function tryShoot(target:TargetResult)
	{
		if (weapon == null)
		{
			return;
		}

		weapon.entity.fireEvent(new ShootEvent(target.cursor, shooter));
	}

	function tryReload()
	{
		if (weapon == null)
		{
			return;
		}

		weapon.entity.fireEvent(new ReloadEvent(shooter));
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
			case CMD_CANCEL:
				game.screens.pop();
			case CMD_CONFIRM, CMD_SHOOT:
				tryShoot(result);
			case CMD_CONSOLE:
				game.screens.push(new ConsoleScreen());
			case CMD_CYCLE_INPUT:
				cycleNextTarget();
			case CMD_CYCLE_INPUT_REVERSE:
				cyclePreviousTarget();
			case CMD_RELOAD:
				tryReload();
			case _:
		}
	}

	override function onMouseDown(pos:Coordinate)
	{
		tryShoot(result);
	}

	public override function onDestroy()
	{
		super.onDestroy();

		var highlights = new Query({
			all: [Highlight],
		});

		highlights.each((entity:Entity) ->
		{
			entity.remove(Highlight);
		});

		targetEntityId = null;
	}

	private function look(dir:Cardinal)
	{
		cursor = cursor.add(dir.toOffset().asWorld());
	}

	private function cycleNextTarget()
	{
		if (target == null)
		{
			var closest = getClosestTarget();
			targetEntityId = closest == null ? null : closest.id;
			return;
		}

		var sorted = getSortedTargets();
		var idx = sorted.indexOf(target);
		var nextIdx = idx + 1;
		var next = nextIdx >= sorted.length ? sorted[0] : sorted[nextIdx];
		if (next != null)
		{
			targetEntityId = next.id;
		}
	}

	private function cyclePreviousTarget()
	{
		if (target == null)
		{
			var closest = getClosestTarget();
			targetEntityId = closest == null ? null : closest.id;
			return;
		}

		var sorted = getSortedTargets();
		var idx = sorted.indexOf(target);
		var nextIdx = idx - 1;
		var next = nextIdx < 0 ? sorted.last() : sorted[nextIdx];
		if (next != null)
		{
			targetEntityId = next.id;
		}
	}

	private function getSortedTargets()
	{
		return targets.sort((a, b) ->
		{
			// var aDist = shooter.pos.distance(a.pos);
			// var bDist = shooter.pos.distance(b.pos);
			var aDist = a.pos.sub(shooter.pos).radians();
			var bDist = b.pos.sub(shooter.pos).radians();

			return aDist > bDist ? 1 : -1;
		});
	}

	private function getClosestTarget()
	{
		return targets.min(e -> e.pos.distance(shooter.pos));
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

	function get_target():Null<Entity>
	{
		return targets.find((t) -> t.id == targetEntityId);
	}
}
