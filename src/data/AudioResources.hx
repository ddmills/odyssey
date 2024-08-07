package data;

import hxd.res.Sound;

class AudioResources
{
	public static var audio:Map<AudioKey, Sound> = [];

	public static function Get(type:AudioKey):Sound
	{
		if (type.isNull())
		{
			return null;
		}
		return audio.get(type);
	}

	public static function Init()
	{
		if (hxd.res.Sound.supportedFormat(OggVorbis))
		{
			var r = hxd.Res.sound;

			audio.set(CHEST_OPEN, r.chest_open);
			audio.set(CHEST_CLOSE, r.chest_close);

			audio.set(LOOT_PICKUP_1, r.take);
			audio.set(LOOT_DROP_1, r.drop_1);

			audio.set(GUN_HANDLE_1, r.gun_handle_1);
			audio.set(GUN_HANDLE_2, r.gun_handle_2);
			audio.set(GUN_HANDLE_3, r.gun_handle_3);
			audio.set(GUN_HANDLE_4, r.gun_handle_4);
			audio.set(GUN_HANDLE_5, r.gun_handle_5);

			audio.set(RELOAD_CLIP_1, r.reload_clip_1);
			audio.set(RELOAD_CLIP_2, r.reload_clip_2);
			audio.set(RELOAD_CLIP_3, r.reload_clip_3);
			audio.set(RELOAD_CLIP_4, r.reload_clip_4);
			audio.set(RELOAD_CLIP_5, r.reload_clip_5);
			audio.set(RELOAD_CLIP_6, r.reload_clip_6);

			audio.set(UNLOAD_CLIP_1, r.unload_clip_1);
			audio.set(UNLOAD_CLIP_2, r.unload_clip_2);
			audio.set(UNLOAD_CLIP_3, r.unload_clip_3);

			audio.set(CLOTH_EQUIP_1, r.cloth_equip_1);
			audio.set(CLOTH_UNEQUIP_1, r.cloth_unequip);

			audio.set(IMPACT_FLESH_1, r.impact_flesh_1);
			audio.set(IMPACT_FLESH_2, r.impact_flesh_2);
			audio.set(IMPACT_FLESH_3, r.impact_flesh_3);

			audio.set(SHOT_SHOTGUN_1, r.shot_shotgun_1);
			audio.set(SHOT_SHOTGUN_2, r.shot_shotgun_2);
			audio.set(SHOT_SHOTGUN_3, r.shot_shotgun_3);
			audio.set(SHOT_SHOTGUN_4, r.shot_shotgun_4);
			audio.set(SHOT_PISTOL_1, r.shot_pistol_1);
			audio.set(SHOT_PISTOL_2, r.shot_pistol_2);

			audio.set(SHOT_RIFLE_1, r.shot_rifle_1);
			audio.set(SHOOT_NO_AMMO_1, r.shoot_no_ammo_1);
			audio.set(EXPLOSION_STONE, r.explosion_stone);
			audio.set(IGNITE_MATCH, r.ignite_match);
			audio.set(RUSTLING_1, r.rustling_1);

			audio.set(WOOD_DESTROY_1, r.wood_destroy_1);
			audio.set(WOOD_DESTROY_2, r.wood_destroy_2);
			audio.set(TREE_FALL_1, r.tree_fall_1);
			audio.set(PRAY_1, r.pray_1);
		}
		else
		{
			trace('OggVorbis NOT SUPPORTED');
		}
	}
}
