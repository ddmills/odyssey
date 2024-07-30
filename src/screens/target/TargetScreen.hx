package screens.target;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Frame;
import core.Game;
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
import h2d.Graphics;
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
	targetQuery:Query,
	range:Int,
	onConfirm:(result:TargetResult) -> Void,
	onCancel:() -> Void,
}

class TargetScreen extends Screen
{
	var targeter:Entity;
	var settings:TargetSettings;
	var origin:Coordinate;
	var cursor:Coordinate;
	var ob:Object;
	var rangeOb:Object;
	var footprintOb:Object;
	var result:TargetResult;

	var targetBm:Anim;
	var targetShader:SpriteShader;

	var targets:Query;
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
		footprintOb = new Object(ob);

		targetShader = new SpriteShader(ColorKey.C_YELLOW_0);
		targetShader.isShrouded = 0;
		targetShader.clearBackground = 0;

		targetBm = new Anim(AnimationResources.Get(CURSOR_SPIN), 10, ob);
		targetBm.addShader(targetShader);

		targets = settings.targetQuery;
		highlights = new Query({
			all: [Highlight],
		});
	}

	override function onEnter()
	{
		game.render(GROUND, ob);
		targetEntityId = null;
		cursor = targeter.pos.floor();
		var closest = getClosestTarget();
		if (closest != null)
		{
			targetEntityId = closest.id;
		}
		drawRangeCircle();
	}

	override function onDestroy()
	{
		ob.remove();

		var highlights = new Query({
			all: [Highlight],
		});

		highlights.each((entity:Entity) ->
		{
			entity.remove(Highlight);
		});

		targetEntityId = null;
	}

	override function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		cursor = pos;
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
		cursor = cursor.add(dir.toOffset().asWorld());
	}

	override function update(frame:Frame)
	{
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
				highlight.color = ColorKey.C_YELLOW_2;
			}
			else
			{
				highlight.showArrow = false;
				highlight.showRing = true;
				highlight.animated = false;
				highlight.color = ColorKey.C_YELLOW_2;
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

		var cursorPx = cursor.sub(originPx).toPx();

		var area = settings.footprint.getFootprint(targeter.pos, cursor.toWorld().floor());

		drawFootprint(area);

		var targetPosPx = cursor.toPx();
		targetBm.setPosition(targetPosPx.x, targetPosPx.y);
		targetBm.visible = targetEntityId == null;

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

		var shader = new SpriteShader(C_RED_4, C_GRAY_1);
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
		var rangeArea = (new CircleFootprint(settings.range)).getFootprint(targeter.pos, targeter.pos.floor());
		var shader = new SpriteShader(C_GRAY_1, C_GRAY_1);
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
			bm.alpha = .2;
			bm.addShader(shader);

			var pos = p.asWorld().sub(targeter.pos).toPx();

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

	private function getSortedTargets()
	{
		return targets.sort((a, b) ->
		{
			var aDist = a.pos.sub(targeter.pos).radians();
			var bDist = b.pos.sub(targeter.pos).radians();

			return aDist > bDist ? 1 : -1;
		});
	}

	private function getClosestTarget()
	{
		return targets.min(e -> e.pos.distance(targeter.pos));
	}

	function get_target():Null<Entity>
	{
		return targets.find((t) -> t.id == targetEntityId);
	}
}
