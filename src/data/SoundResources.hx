package data;

import hxd.res.Sound;

class SoundResources
{
	public static var CHEST_OPEN:Sound;
	public static var CHEST_CLOSE:Sound;

	public static var LOOT_PICKUP_1:Sound;
	public static var LOOT_DROP_1:Sound;

	public static var GUN_HANDLE_1:Sound;
	public static var GUN_HANDLE_2:Sound;
	public static var GUN_HANDLE_3:Sound;
	public static var GUN_HANDLE_4:Sound;
	public static var GUN_HANDLE_5:Sound;

	public static var CLOTH_EQUIP_1:Sound;
	public static var CLOTH_UNEQUIP_1:Sound;

	public static var IMPACT_FLESH_1:Sound;
	public static var IMPACT_FLESH_2:Sound;
	public static var IMPACT_FLESH_3:Sound;

	public static var RELOAD_CLIP_1:Sound;
	public static var RELOAD_CLIP_2:Sound;
	public static var RELOAD_CLIP_3:Sound;
	public static var RELOAD_CLIP_4:Sound;

	public static var SHOT_SHOTGUN_1:Sound;
	public static var SHOT_SHOTGUN_2:Sound;
	public static var SHOT_SHOTGUN_3:Sound;
	public static var SHOT_SHOTGUN_4:Sound;

	public static var SHOT_PISTOL_1:Sound;
	public static var SHOT_PISTOL_2:Sound;

	// public static var SHOT_PISTOL_3:Sound;
	// public static var SHOT_PISTOL_4:Sound;
	public static var SHOT_RIFLE_1:Sound;

	// public static var SHOT_RIFLE_2:Sound;
	// public static var SHOT_RIFLE_3:Sound;
	// public static var SHOT_RIFLE_4:Sound;

	public static function Init()
	{
		if (hxd.res.Sound.supportedFormat(OggVorbis))
		{
			CHEST_OPEN = hxd.Res.sound.chest_open;
			CHEST_CLOSE = hxd.Res.sound.chest_close;

			LOOT_PICKUP_1 = hxd.Res.sound.take;
			LOOT_DROP_1 = hxd.Res.sound.drop_1;

			GUN_HANDLE_1 = hxd.Res.sound.gun_handle_1;
			GUN_HANDLE_2 = hxd.Res.sound.gun_handle_2;
			GUN_HANDLE_3 = hxd.Res.sound.gun_handle_3;
			GUN_HANDLE_4 = hxd.Res.sound.gun_handle_4;
			GUN_HANDLE_5 = hxd.Res.sound.gun_handle_5;

			CLOTH_EQUIP_1 = hxd.Res.sound.cloth_equip_1;
			CLOTH_UNEQUIP_1 = hxd.Res.sound.cloth_unequip;

			IMPACT_FLESH_1 = hxd.Res.sound.impact_flesh_1;
			IMPACT_FLESH_2 = hxd.Res.sound.impact_flesh_2;
			IMPACT_FLESH_3 = hxd.Res.sound.impact_flesh_3;

			SHOT_SHOTGUN_1 = hxd.Res.sound.shot_shotgun_1;
			SHOT_SHOTGUN_2 = hxd.Res.sound.shot_shotgun_2;
			SHOT_SHOTGUN_3 = hxd.Res.sound.shot_shotgun_3;
			SHOT_SHOTGUN_4 = hxd.Res.sound.shot_shotgun_4;
			SHOT_PISTOL_1 = hxd.Res.sound.shot_pistol_1;
			SHOT_PISTOL_2 = hxd.Res.sound.shot_pistol_2;
			// SHOT_PISTOL_3 = hxd.Res.sound.shot_pistol_3;
			// SHOT_PISTOL_4 = hxd.Res.sound.shot_pistol_4;
			SHOT_RIFLE_1 = hxd.Res.sound.shot_rifle_1;
			// SHOT_RIFLE_2 = hxd.Res.sound.shot_rifle_2;
			// SHOT_RIFLE_3 = hxd.Res.sound.shot_rifle_3;
			// SHOT_RIFLE_4 = hxd.Res.sound.shot_rifle_4;
		}
		else
		{
			trace('OggVorbis NOT SUPPORTED');
		}
	}
}
