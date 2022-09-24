package data.save;

import common.struct.Grid.GridSave;
import domain.terrain.TerrainType;
import ecs.Entity.EntitySaveData;

typedef SavePlayer =
{
	entity:EntitySaveData,
};

typedef SaveMapTile =
{
	idx:Int,
	terrain:TerrainType,
	biomes:Map<BiomeType, Float>,
	biomeKey:BiomeType,
	color:Int,
	bgTileKey:TileKey,
	bgColor:Int,
};

typedef SaveMap =
{
	tiles:GridSave<SaveMapTile>,
};

typedef SaveWorld =
{
	seed:Int,
	map:SaveMap,
	player:SavePlayer,
	tick:Int,
	chunkSize:Int,
	chunkCountX:Int,
	chunkCountY:Int,
}
