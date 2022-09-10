package core;

import data.AudioKey;
import data.AudioResources;

class AudioManager
{
	public function new()
	{
		var manager = hxd.snd.Manager.get();
		manager.masterVolume = 0.25;
	}

	public function play(key:Null<AudioKey>)
	{
		var sound = AudioResources.Get(key);

		if (sound == null)
		{
			return;
		}

		sound.play();
	}
}
