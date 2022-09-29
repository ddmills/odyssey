package data.save;

import common.struct.Grid.GridSave;
import data.BiomeMap.BiomeChunkData;
import domain.terrain.Cell;
import ecs.Entity.EntitySaveData;

typedef SaveChunk =
{
	var idx:Int;
	var size:Int;
	var explored:GridSave<Bool>;
	var entities:GridSave<Array<EntitySaveData>>;
	var tick:Int;
	var cells:GridSave<Cell>;
}
