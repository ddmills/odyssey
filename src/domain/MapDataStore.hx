package domain;

import common.struct.IntPoint;
import data.BiomeType;
import domain.terrain.Cell;
import ecs.Entity;
import h2d.Bitmap;

interface MapDataStore
{
	function getEntityIdsAt(worldPos:IntPoint):Array<String>;
	function updateEntityPosition(entity:Entity, targetWorldPos:IntPoint):Void;
	function getBiomeType(worldPos:IntPoint):BiomeType;
	function setVisible(worldPos:IntPoint):Void;
	function setExplore(worldPos:IntPoint, isExplored:Bool, isVisible:Bool):Void;
	function isExplored(worldPos:IntPoint):Bool;
	function getCell(worldPos:IntPoint):Cell;
	function getBackgroundBitmap(worldPos:IntPoint):Bitmap;
}
