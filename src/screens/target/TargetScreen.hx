package screens.target;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.AnimationResources;
import data.Bitmasks;
import data.Cardinal;
import data.ColorKey;
import data.TileResources;
import domain.components.Highlight;
import ecs.Entity;
import ecs.Query;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Object;
import screens.console.ConsoleScreen;
import screens.target.footprints.CircleFootprint;
import screens.target.footprints.Footprint;
import shaders.SpriteShader;

enum TargetOrigin
{
	CURSOR;
	TARGETER;
}

typedef TargetResult =
{
	area:Array<IntPoint>,
	origin:IntPoint,
	cursor:IntPoint,
}

typedef TargetSettings =
{
	origin:TargetOrigin,
	footprint:Footprint,
	showFootprint:Bool,
	getTargets:() -> Array<Entity>,
	range:Int,
	allowOutsideRange:Bool,
	onConfirm:(result:TargetResult) -> Void,
	onCancel:() -> Void,
}

class TargetScreen extends Screen
{
	var targeter:Entity;
	var settings:TargetSettings;
	var origin:Coordinate;
	var cursor(default, set):Coordinate;
	var ob:Object;
	var rangeOb:Object;
	var footprintOb:Object;
	var result:TargetResult;
	var rangeArea:Array<IntPoint>;

	var targetBm:Anim;
	var targetShader:SpriteShader;

	var targets:Array<Entity>;
	var highlights:Query;
	var targetEntityId:Null<String>;
	var target(get, never):Null<Entity>;

	public function new(targeter:Entity, settings:TargetSettings)
	{
		this.targeter = targeter;
		this.settings = settings;

		inputDomain = INPUT_DOMAIN_ADVENTURE;
		ob = new Object();
		rangeOb = new Object(ob);
		footprintOb = new Object();

		targetShader = new SpriteShader(ColorKey.C_YELLOW);
		targetShader.isShrouded = 0;
		targetShader.clearBackground = 0;

		targetBm = new Anim(AnimationResources.Get(CURSOR_SPIN), 10, ob);
		targetBm.addShader(targetShader);

		targets = settings.getTargets();
		highlights = new Query({
			all: [Highlight],
		});
	}

	override function onEnter()
	{
		game.render(OVERLAY, ob);
		game.render(GROUND, footprintOb);
		targetEntityId = null;
		drawRangeCircle();
		cursor = targeter.pos.floor();
		var closest = getClosestTarget();
		if (closest != null)
		{
			targetEntityId = closest.id;
		}
	}

	override function onDestroy()
	{
		ob.remove();
		footprintOb.remove();

		highlights.each((entity:Entity) ->
		{
			entity.remove(Highlight);
		});

		targetEntityId = null;
	}

	override function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		var prevWorld = previous.toWorld().floor();
		var curWorld = pos.toWorld().floor();

		if (!curWorld.equals(prevWorld))
		{
			cursor = curWorld;
			targetEntityId = null;
		}
	}

	override function onMouseDown(pos:Coordinate)
	{
		onConfirm();
	}

	function onConfirm()
	{
		settings.onConfirm(result);
	}

	function onCancel()
	{
		settings.onCancel();
	}

	private function look(dir:Cardinal)
	{
		targetEntityId = null;
		cursor = cursor.toWorld().add(dir.toOffset().asWorld());
	}

	override function update(frame:Frame)
	{
		targets = settings.getTargets();

		if (settings.origin == TARGETER)
		{
			origin = targeter.pos.floor();
		}
		else if (settings.origin == CURSOR)
		{
			origin = cursor.toWorld().floor();
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
			var localPos = targeter.pos.sub(t.pos).toIntPoint();

			if (!isInRange(localPos))
			{
				t.remove(Highlight);

				if (t.id == targetEntityId)
				{
					targetEntityId = null;
				}
				return;
			}

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
				highlight.showRing = true;
				highlight.animated = true;
				highlight.color = ColorKey.C_YELLOW;
			}
			else
			{
				highlight.showArrow = false;
				highlight.showRing = true;
				highlight.animated = false;
				highlight.color = ColorKey.C_YELLOW;
			}
		});

		world.updateSystems();

		if (world.systems.energy.isPlayersTurn)
		{
			var cmd = game.commands.peek();
			if (cmd != null)
			{
				handleInput(game.commands.next());
			}
		}

		var originPx = targeter.pos.toPx();
		ob.x = originPx.x;
		ob.y = originPx.y;
		footprintOb.x = originPx.x;
		footprintOb.y = originPx.y;

		var area = settings.footprint.getFootprint(targeter.pos, cursor.toWorld().floor());

		drawFootprint(area);

		var cursorPx = cursor.toWorld().sub(origin.toWorld()).floor().toPx();

		targetBm.setPosition(cursorPx.x, cursorPx.y);
		targetBm.visible = target.isNull();

		result = {
			area: area,
			origin: targeter.pos.toIntPoint(),
			cursor: cursor.toWorld().toIntPoint(),
		};
	}

	private function drawFootprint(area:Array<IntPoint>)
	{
		footprintOb.removeChildren();

		if (!settings.showFootprint)
		{
			return;
		}

		var shader = new SpriteShader(C_DARK_RED, C_LIGHT_GRAY);
		shader.isShrouded = 0;

		for (p in area)
		{
			var mask = Bitmasks.SumMask((x, y) ->
			{
				var local = p.add(x, y);
				return area.exists((point) -> point.equals(local));
			});

			var tileKey = Bitmasks.GetTileKey(BITMASK_HIGHLIGHT, mask);
			var a = new Bitmap(TileResources.Get(tileKey), footprintOb);
			a.visible = settings.showFootprint;
			a.alpha = .5;
			a.addShader(shader);

			var pos = p.asWorld().sub(targeter.pos).toPx();

			a.x = pos.x;
			a.y = pos.y;
		}
	}

	private function drawRangeCircle()
	{
		rangeOb.removeChildren();
		rangeArea = (new CircleFootprint(settings.range)).getFootprint(new Coordinate(0, 0, WORLD), new Coordinate(0, 0, WORLD));
		var shader = new SpriteShader(C_LIGHT_GRAY, C_LIGHT_GRAY);
		shader.isShrouded = 0;

		for (p in rangeArea)
		{
			var mask = Bitmasks.SumMask((x, y) ->
			{
				var local = p.add(x, y);
				return rangeArea.exists((point) -> point.equals(local));
			});

			var tileKey = Bitmasks.GetTileKey(BITMASK_HIGHLIGHT_DASH, mask);
			var bm = new Bitmap(TileResources.Get(tileKey), rangeOb);
			bm.alpha = .5;
			bm.addShader(shader);

			var pos = p.asWorld().toPx();

			bm.x = pos.x;
			bm.y = pos.y;
		}
	}

	private function handleInput(command:Command)
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
			case CMD_CONFIRM, CMD_SHOOT:
				onConfirm();
			case CMD_CANCEL:
				onCancel();
			case CMD_CONSOLE:
				game.screens.push(new ConsoleScreen());
			case CMD_CYCLE_INPUT:
				cycleNextTarget();
			case CMD_CYCLE_INPUT_REVERSE:
				cyclePreviousTarget();
			case _:
		}
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

	private function getValidTargets():Array<Entity>
	{
		return targets.filter(t ->
		{
			var localPos = targeter.pos.sub(t.pos).toIntPoint();
			return isInRange(localPos);
		});
	}

	private function isInRange(localPos:IntPoint):Bool
	{
		if (settings.allowOutsideRange)
		{
			return true;
		}

		return rangeArea.exists((p) -> p.equals(localPos));
	}

	private function getSortedTargets():Array<Entity>
	{
		var valid = getValidTargets();

		valid.sort((a, b) ->
		{
			var aDist = a.pos.sub(targeter.pos).radians();
			var bDist = b.pos.sub(targeter.pos).radians();

			return aDist > bDist ? 1 : -1;
		});

		return valid;
	}

	private function getClosestTarget()
	{
		return getSortedTargets()?.first();
	}

	function get_target():Null<Entity>
	{
		return targets.find((t) -> t.id == targetEntityId);
	}

	function set_cursor(value:Coordinate):Coordinate
	{
		var world = value.toWorld();
		var localPos = world.sub(targeter.pos).toIntPoint();

		if (isInRange(localPos))
		{
			cursor = value;
			return value;
		}

		if (rangeArea.exists((p) -> p.equals(localPos)))
		{
			cursor = value;
			return value;
		}

		if (cursor == null)
		{
			cursor = targeter.pos;
		}

		return cursor;
	}
}
