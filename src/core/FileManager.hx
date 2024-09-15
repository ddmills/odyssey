package core;

import common.tools.Performance;
import common.util.FS;
import data.save.ChunkSave;
import data.save.RealmSave;
import data.save.SaveWorld;
import hxd.Save;
import sys.FileSystem;

class FileManager
{
	var saveName:String;
	var saveDirectory = 'saves';

	public function new() {}

	public function setSaveName(name:String)
	{
		saveName = name;
		FileSystem.createDirectory(filePath(['chunks']));
		FileSystem.createDirectory(filePath(['realms']));
	}

	private function filePath(parts:Array<String>):String
	{
		var all = [saveDirectory, saveName].concat(parts);
		return all.join('/');
	}

	public function deleteSave(name:String)
	{
		FS.deletePath('$saveDirectory/$name', true);
	}

	public function saveChunk(data:ChunkSave)
	{
		var isSaved = Save.save(data, filePath(['chunks', 'chunk-${data.idx}']));
		if (!isSaved)
		{
			trace('chunk not saved!', data.idx);
		}
		return isSaved;
	}

	public function saveRealm(data:RealmSave)
	{
		var isSaved = Save.save(data, filePath(['realms', 'realm-${data.realmId}']));
		if (!isSaved)
		{
			trace('realm not saved!', data.realmId);
		}
		return isSaved;
	}

	public function tryReadChunk(idx:Int):Null<ChunkSave>
	{
		var name = filePath(['chunks', 'chunk-$idx']);
		return Save.load(null, name);
	}

	public function tryReadRealm(realmId:String):Null<RealmSave>
	{
		var name = filePath(['realms', 'realm-$realmId']);
		return Save.load(null, name);
	}

	public function saveWorld(data:SaveWorld)
	{
		Performance.start('fs-world-save');
		var isSaved = Save.save(data, filePath(['world']));
		if (!isSaved)
		{
			trace('world not saved!');
		}
		Performance.stop('fs-world-save', true);
		return isSaved;
	}

	public function tryReadWorld():SaveWorld
	{
		Performance.start('fs-world-load');
		var name = filePath(['world']);
		var data = Save.load(null, name);
		Performance.stop('fs-world-load', true);
		return data;
	}
}
