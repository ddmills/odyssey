package domain.terrain.biomes;

import common.struct.IntPoint;
import data.ColorKey;
import data.TileKey;
import domain.prefabs.Spawner;

class SwampBiome extends Biome
{
	var waterLine = .38;

	public function new(seed:Int)
	{
		super(seed, SWAMP, C_PURPLE_3);
	}

	function getBackgroundTileKey(pos:IntPoint):TileKey
	{
		var grass = r.bool(.05);
		if (grass)
		{
			return GRASS_V1_3;
		}

		var p = perlin.get(pos, 6);
		var h = p.pow(2);

		if (h > .56)
		{
			return SWAMP_V2_3;
		}

		if (h > .5)
		{
			return SWAMP_V2_2;
		}

		if (h > .46)
		{
			return SWAMP_V2_1;
		}

		if (h > .35)
		{
			return TERRAIN_BASIC_2;
		}

		return TERRAIN_BASIC_1;
	}

	override function setCellData(pos:IntPoint, cell:Cell)
	{
		var h = perlin.get(pos, 16, 8);

		if (h < waterLine)
		{
			cell.tileKey = WATER_1;
			cell.terrain = TERRAIN_WATER;
			cell.primary = C_BLUE_2;
			cell.background = C_BLUE_3;
		}
		else
		{
			cell.tileKey = getBackgroundTileKey(pos);
			cell.terrain = TERRAIN_MUD;
			cell.primary = C_PURPLE_2;
			cell.background = C_PURPLE_3;
		}
	}

	private function getHeight(p:IntPoint):Float
	{
		return perlin.get(p.x, p.y, 16, 8);
	}

	override function spawnEntity(pos:IntPoint, cell:Cell)
	{
		var h = perlin.get(pos, 16, 8);

		if (h < waterLine && r.bool(.125))
		{
			Spawner.Spawn(BALD_CYPRESS, pos.asWorld());
		}
		else if (r.bool(.05))
		{
			Spawner.Spawn(BALD_CYPRESS, pos.asWorld());
		}
		else if (r.bool(.05))
		{
			Spawner.Spawn(CORPSE_SNAKE, pos.asWorld());
		}
		else if (r.bool(.05))
		{
			Spawner.Spawn(CORPSE_HUMAN, pos.asWorld());
		}
	}
}
