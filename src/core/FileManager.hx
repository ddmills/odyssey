package core;

import common.tools.Performance;
import data.save.SaveChunk;
import hxd.Save;
import sys.FileSystem;

class FileManager
{
	var chunkSaveData:Map<Int, SaveChunk>;
	var saveName:String;
	var saveDirectory = 'saves';

	public function new()
	{
		saveName = 'dev';
		chunkSaveData = new Map();
		FileSystem.createDirectory(filePath(['chunks']));
	}

	private function filePath(parts:Array<String>):String
	{
		var all = [saveDirectory, saveName].concat(parts);
		return all.join('/');
	}

	public function saveChunk(data:SaveChunk)
	{
		Performance.start('chunk-save-file');
		var isSaved = Save.save(data, filePath(['chunks', 'chunk-${data.idx}']));
		if (!isSaved)
		{
			trace('chunk not saved!', data.idx);
		}
		trace(Performance.stop('chunk-save-file'));
		return isSaved;
	}

	public function tryReadChunk(idx:Int):Null<SaveChunk>
	{
		var name = filePath(['chunks', 'chunk-$idx']);
		return Save.load(null, name);
	}
}
