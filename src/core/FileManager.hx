package core;

import common.tools.Performance;
import data.save.SaveChunk;
import data.save.SaveWorld;
import domain.World;
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
	}

	private function filePath(parts:Array<String>):String
	{
		var all = [saveDirectory, saveName].concat(parts);
		return all.join('/');
	}

	public function saveChunk(data:SaveChunk)
	{
		var isSaved = Save.save(data, filePath(['chunks', 'chunk-${data.idx}']));
		if (!isSaved)
		{
			trace('chunk not saved!', data.idx);
		}
		return isSaved;
	}

	public function tryReadChunk(idx:Int):Null<SaveChunk>
	{
		var name = filePath(['chunks', 'chunk-$idx']);
		return Save.load(null, name);
	}

	public function saveWorld(data:SaveWorld)
	{
		var isSaved = Save.save(data, filePath(['world']));
		if (!isSaved)
		{
			trace('world not saved!');
		}
		return isSaved;
	}

	public function tryReadWorld():SaveWorld
	{
		var name = filePath(['world']);
		return Save.load(null, name);
	}
}
