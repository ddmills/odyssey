package data.save;

import common.struct.Grid.GridSave;
import domain.terrain.Cell;
import ecs.Entity.EntitySaveData;

typedef SavePlayer =
{
	entity:EntitySaveData,
};

typedef SaveMap =
{
	cells:GridSave<Cell>,
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
