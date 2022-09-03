package core;

import hxd.res.Sound;

class SoundManager
{
	public function new() {}

	public function play(sound:Sound)
	{
		if (sound == null)
		{
			return;
		}
		sound.play();
	}
}
