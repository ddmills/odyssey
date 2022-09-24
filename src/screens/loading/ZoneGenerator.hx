package screens.loading;

import common.rand.Perlin;
import common.struct.Grid;
import common.tools.Performance;
import core.Game;
import data.BiomeType;
import domain.World;
import hxd.Rand;

class ZoneGenerator
{
	var perlin:Perlin;
	var game(get, never):Game;
	var world(get, never):World;
	var seed(get, never):Int;
	var r:Rand;

	public var zones:Grid<Zone>;

	public function new() {}

	public function initialize()
	{
		r = new Rand(seed + 1992);
		zones = new Grid(world.zoneCountX, world.zoneCountY);

		Performance.start('zones');
		zones.fillFn((idx) ->
		{
			return {
				idx: idx,
				biome: r.pick([BiomeType.PRAIRIE, BiomeType.TUNDRA]),
			};
		});
		Performance.stop('zones');
		Performance.trace('zones');
	}

	inline function get_world():World
	{
		return Game.instance.world;
	}

	inline function get_seed():Int
	{
		return world.seed;
	}

	inline function get_game():Game
	{
		return Game.instance;
	}
}
