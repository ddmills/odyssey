package domain.systems;

import common.algorithm.Shadowcast;
import common.struct.IntPoint;
import common.util.Colors;
import core.Frame;
import domain.components.IsDestroyed;
import domain.components.LightBlocker;
import domain.components.LightSource;
import ecs.Query;
import ecs.System;
import shaders.SpriteShader;

typedef LightFragment =
{
	pos:IntPoint,
	distance:Float,
	intensity:Float,
	color:Int,
	source:IntPoint,
	sourceId:String,
}

typedef TileLightData =
{
	intensity:Float,
	color:Int,
}

class LightSystem extends System
{
	var query:Query;
	var flagRecompute:Bool = false;
	private var litTiles:Map<Int, TileLightData> = [];

	public var lightFragments:Map<Int, Array<LightFragment>> = [];

	var darkTile:TileLightData = {
		intensity: 0,
		color: 0,
	};

	public function new()
	{
		query = new Query({
			all: [LightSource],
			none: [IsDestroyed],
		});

		query.onEntityRemoved((e) ->
		{
			flagRecompute = true;
		});
	}

	override function update(frame:Frame)
	{
		if (world.clock.tickDelta <= 0 && !flagRecompute)
		{
			return;
		}

		flagRecompute = false;

		clearLitTiles();

		for (entity in query)
		{
			var light = entity.get(LightSource);

			if (!light.isEnabled)
			{
				continue;
			}

			Shadowcast.Compute({
				start: entity.pos.toIntPoint(),
				distance: light.range,
				isBlocker: (p) ->
				{
					if (world.isOutOfBounds(p))
					{
						return false;
					}

					var entities = world.getEntitiesAt(p.asWorld());

					return entities.exists((e) -> e.has(LightBlocker));
				},
				onLight: (pos, distance) ->
				{
					var d = distance > .75 ? distance - .75 : .75;
					// var d = distance;
					// var i = light.intensity / d; // realistic lighting = d^2
					var i = light.intensity / (d * d); // realistic lighting = d^2

					addFragment({
						pos: pos,
						intensity: i,
						distance: d,
						color: light.color,
						source: entity.pos.toIntPoint(),
						sourceId: entity.id,
					});
				}
			});
		}

		applyLights();
	}

	function addFragment(fragment:LightFragment)
	{
		var idx = world.getTileIdx(fragment.pos);
		var existing = lightFragments.get(idx);
		if (existing == null)
		{
			lightFragments.set(idx, [fragment]);
		}
		else
		{
			var isDuplicate = existing.exists((f) -> f.sourceId == fragment.sourceId);

			if (!isDuplicate)
			{
				existing.push(fragment);
			}
		}
	}

	function combine(fragments:Array<LightFragment>)
	{
		var color:Int = -1;
		var intensity = fragments.sum((f) -> f.intensity);

		for (fragment in fragments)
		{
			if (color <= 0)
			{
				color = fragment.color;
			}
			else
			{
				color = Colors.Mix(color, fragment.color, fragment.intensity / intensity);
			}
		}

		return {
			color: color,
			intensity: intensity.clamp(0, 1),
		};
	}

	function applyLights()
	{
		var walls:Map<Int, Array<LightFragment>> = new Map();
		var floors:Map<Int, Array<LightFragment>> = new Map();

		for (idx => fragmentList in lightFragments)
		{
			var pos = world.getTilePos(idx);
			var shader = getShader(pos);
			var entities = world.getEntitiesAt(pos);

			if (entities.exists((e) -> e.has(LightBlocker)))
			{
				walls.set(idx, fragmentList);
				continue;
			}

			floors.set(idx, fragmentList);

			if (shader != null)
			{
				var compiled = combine(fragmentList);
				shader.lightColor = compiled.color.toHxdColor().toVector();
				shader.lightIntensity = compiled.intensity.clamp(0, 1);
				shader.isLit = 1;
				litTiles.set(idx, {
					intensity: compiled.intensity,
					color: compiled.color,
				});
			}
		}

		var pov = world.player.entity.pos.toWorld().toIntPoint();

		for (idx => fragmentList in walls)
		{
			var pos = world.getTilePos(idx);
			var offset = pov.sub(pos).cardinal().toOffset();
			var offsetTile = pos.add(offset);
			var offsetTileIdx = world.getTileIdx(offsetTile);
			var floorAtOffset = floors.get(offsetTileIdx);
			var validFragments:Array<LightFragment> = [];
			var color:Int = -1;
			var intensity:Float = 0;

			if (floorAtOffset == null)
			{
				continue;
			}

			for (fragment in fragmentList)
			{
				var hasLitFloor = floorAtOffset.exists((f) ->
				{
					return f.sourceId == fragment.sourceId;
				});

				if (!hasLitFloor)
				{
					continue;
				}

				intensity += fragment.intensity;
				validFragments.push(fragment);
			}

			for (fragment in validFragments)
			{
				if (color <= 0)
				{
					color = fragment.color;
				}
				else
				{
					color = Colors.Mix(color, fragment.color, fragment.intensity / intensity);
				}
			}

			var shader = getShader(pos);
			if (shader != null)
			{
				var outIntensity = intensity.clamp(0, 1);
				shader.lightColor = color.toHxdColor().toVector();
				shader.lightIntensity = outIntensity;
				shader.isLit = 1;
				litTiles.set(idx, {
					intensity: outIntensity,
					color: color,
				});
			}
		}
	}

	public function getTileLight(pos:IntPoint):Null<TileLightData>
	{
		var idx = world.getTileIdx(pos);
		return litTiles.get(idx).or(darkTile);
	}

	public function clearLitTiles()
	{
		for (idx in lightFragments.keys())
		{
			var pos = world.getTilePos(idx);
			var shader = getShader(pos);
			if (shader != null)
			{
				shader.isLit = 0;
			}
		}
		litTiles = [];
		lightFragments = [];
	}

	private function getShader(pos:IntPoint):SpriteShader
	{
		var bm = world.map.getBackgroundBitmap(pos);
		if (bm == null)
		{
			return null;
		}

		return bm.getShader(SpriteShader);
	}
}
