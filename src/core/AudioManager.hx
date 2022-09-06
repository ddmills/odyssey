package core;

import hxd.res.Sound;

class AudioManager
{
	public function new()
	{
		var manager = hxd.snd.Manager.get();
		manager.masterVolume = 0.25;
	}

	public function play(sound:Sound)
	{
		if (sound == null)
		{
			return;
		}
		sound.play();
	}
}
