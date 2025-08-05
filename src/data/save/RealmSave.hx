package data.save;

import common.struct.Grid.GridSave;
import domain.terrain.Cell;
import ecs.Entity.EntitySaveData;

typedef RealmSave =
{
	var realmId:String;
	var size:Int;
	var explored:GridSave<Bool>;
	var entities:GridSave<Array<EntitySaveData>>;
	var tick:Int;
	var cells:GridSave<Cell>;
}
