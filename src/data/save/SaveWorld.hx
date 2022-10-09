package data.save;

import domain.data.factions.FactionManager.FactionManagerSave;
import domain.systems.StorylineSystem.StorylineSystemSave;
import domain.terrain.Zone.ZoneSave;
import domain.terrain.ZoneManager.ZoneManagerSave;
import domain.terrain.gen.ZonePoi.ZonePoiSave;
import domain.terrain.gen.railroad.RailroadData.RailroadDataSave;
import ecs.Entity.EntitySaveData;

typedef SavePlayer =
{
	entity:EntitySaveData,
};

typedef SaveMap =
{
	pois:Array<ZonePoiSave>,
	railroad:RailroadDataSave,
};

typedef SaveWorld =
{
	seed:Int,
	map:SaveMap,
	zones:ZoneManagerSave,
	player:SavePlayer,
	factions:FactionManagerSave,
	tick:Int,
	chunkSize:Int,
	chunkCountX:Int,
	chunkCountY:Int,
	detachedEntities:Array<EntitySaveData>,
	storylines:StorylineSystemSave,
}
