package domain.systems;

import common.algorithm.Shadowcast;
import common.struct.IntPoint;
import common.util.Colors;
import core.Frame;
import data.Cardinal;
import domain.components.Collider;
import domain.components.Energy;
import domain.components.IsDestroyed;
import domain.components.IsInventoried;
import domain.components.LightBlocker;
import domain.components.LightSource;
import ecs.Query;
import ecs.System;
import h2d.Bitmap;
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

class LightSystem extends System
{
	var query:Query;

	public var lightFragments:Map<Int, Array<LightFragment>> = [];

	public function new()
	{
		query = new Query({
			all: [LightSource],
			none: [IsDestroyed],
		});
	}

	override function update(frame:Frame)
	{
		if (world.clock.tickDelta <= 0)
		{
			return;
		}

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
					if (world.map.tiles.isOutOfBounds(p.x, p.y))
					{
						return false;
					}

					var entities = world.getEntitiesAt(p.asWorld());

					return entities.exists((e) -> e.has(Collider) || e.has(Energy));
				},
				onLight: (pos, distance) ->
				{
					var d = distance > .5 ? distance - .5 : .5;
					var intensity = 1 - (d / light.range);

					addFragment({
						pos: pos,
						intensity: intensity * light.intensity,
						distance: d,
						color: light.colour,
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
		// if floor, light right away, combine other lights, else save it for later (?)
		var idx = world.map.getTileIdx(fragment.pos);
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
			var pos = world.map.getTilePos(idx);
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
				shader.light = compiled.color.toHxdColor();
				shader.lightIntensity = compiled.intensity.clamp(0, 1);
				shader.isLit = 1;
			}
		}

		var pov = world.player.entity.pos.toWorld().toIntPoint();

		for (idx => fragmentList in walls)
		{
			var pos = world.map.getTilePos(idx);
			var direction = pov.sub(pos);
			var angle = direction.angle().toDegrees();
			var cardinal = Cardinal.fromDegrees(angle);
			var offset = cardinal.toOffset();
			var offsetTile = pos.add(offset);
			var offsetTileIdx = world.map.getTileIdx(offsetTile);
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
				shader.isLit = 1;
				shader.light = color.toHxdColor();
				shader.lightIntensity = intensity.clamp(0, 1);
			}
		}
	}

	public function clearLitTiles()
	{
		for (idx in lightFragments.keys())
		{
			var pos = world.map.getTilePos(idx);
			var shader = getShader(pos);
			if (shader != null)
			{
				shader.isLit = 0;
			}
		}

		lightFragments = [];
	}

	private function getShader(pos:IntPoint):SpriteShader
	{
		var w = pos.asWorld();
		var chunkIdx = w.toChunkIdx();
		var chunk = world.chunks.getChunkById(chunkIdx);

		if (chunk == null || !chunk.isLoaded)
		{
			return null;
		}

		var chunkLocal = w.toChunkLocal().toIntPoint();
		var bm = chunk.bitmaps.get(chunkLocal.x, chunkLocal.y);
		if (bm == null)
		{
			return null;
		}

		return bm.getShader(SpriteShader);
	}
}
