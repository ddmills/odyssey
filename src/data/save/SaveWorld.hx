package data.save;

import domain.systems.StorylineSystem.StorylineSystemSave;
import ecs.Entity.EntitySaveData;

typedef SavePlayer =
{
	entity:EntitySaveData,
};

typedef SaveMap = {};

typedef SaveWorld =
{
	seed:Int,
	map:SaveMap,
	player:SavePlayer,
	tick:Int,
	chunkSize:Int,
	chunkCountX:Int,
	chunkCountY:Int,
	detachedEntities:Array<EntitySaveData>,
	storylines:StorylineSystemSave,
}
