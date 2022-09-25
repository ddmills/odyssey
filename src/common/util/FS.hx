package common.util;

import sys.FileSystem;

class FS
{
	public static inline function deletePath(path:String, recursive:Bool = false):Void
	{
		if (!FileSystem.exists(path))
		{
			return;
		}

		if (!recursive)
		{
			if (FileSystem.isDirectory(path))
			{
				return FileSystem.deleteDirectory(path);
			}
			else
			{
				return FileSystem.deleteFile(path);
			}
		}

		if (FileSystem.isDirectory(path))
		{
			var entries = FileSystem.readDirectory(path);

			for (entry in entries)
			{
				deletePath('$path/$entry');
			}

			return FileSystem.deleteDirectory(path);
		}
		else
		{
			return FileSystem.deleteFile(path);
		}
	}
}
