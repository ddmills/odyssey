package data.save;

import common.struct.Grid.GridSave;
import ecs.Entity.EntitySaveData;

@:structInit class SaveChunk
{
	public var idx:Int;
	public var size:Int;
	public var explored:GridSave<Bool>;
	public var entities:GridSave<Array<EntitySaveData>>;
}
