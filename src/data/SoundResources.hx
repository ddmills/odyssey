package data;

import hxd.res.Sound;

class SoundResources
{
	public static var CHEST_OPEN:Sound;
	public static var CHEST_CLOSE:Sound;

	public static var LOOT_PICKUP_1:Sound;
	public static var LOOT_DROP_1:Sound;

	public static function Init()
	{
		if (hxd.res.Sound.supportedFormat(OggVorbis))
		{
			CHEST_OPEN = hxd.Res.sound.chest_open;
			CHEST_CLOSE = hxd.Res.sound.chest_close;

			LOOT_PICKUP_1 = hxd.Res.sound.take;
			LOOT_DROP_1 = hxd.Res.sound.drop_1;
		}
	}
}
