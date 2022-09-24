package screens.loading;

import common.struct.IntPoint;
import core.Game;
import data.BiomeType;

@:structInit class Zone
{
	public var idx:Int;
	public var pos(get, never):IntPoint;
	public var biome:BiomeType;

	function get_pos():IntPoint
	{
		return Game.instance.world.zones.zones.coord(idx);
	}

	// function getChunks():Array<Chunk> {}
}
