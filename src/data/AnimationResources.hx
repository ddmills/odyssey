package data;

import h2d.Tile;

class AnimationResources
{
	public static var animations:Map<AnimationKey, Array<Tile>> = [];

	public static function Get(key:AnimationKey):Array<Tile>
	{
		if (key.isNull())
		{
			return null;
		}

		var animation = animations.get(key);

		if (animation.isNull())
		{
			return animations.get(CURSOR_SPIN);
		}

		return animation;
	}

	public static function Init()
	{
		animations.set(CURSOR_SPIN, [
			TileResources.Get(CURSOR_SPIN_1),
			TileResources.Get(CURSOR_SPIN_2),
			TileResources.Get(CURSOR_SPIN_3),
			TileResources.Get(CURSOR_SPIN_4),
			TileResources.Get(CURSOR_SPIN_5),
		]);

		animations.set(CAMPFIRE, [
			TileResources.Get(CAMPFIRE_1),
			TileResources.Get(CAMPFIRE_2),
			TileResources.Get(CAMPFIRE_3),
		]);

		animations.set(ARROW_BOUNCE, [
			TileResources.Get(ARROW_BOUNCE_1),
			TileResources.Get(ARROW_BOUNCE_2),
			TileResources.Get(ARROW_BOUNCE_3),
			TileResources.Get(ARROW_BOUNCE_4),
		]);

		animations.set(LIQUID_SPURT, [
			TileResources.Get(LIQUID_SPURT_1),
			TileResources.Get(LIQUID_SPURT_2),
			TileResources.Get(LIQUID_SPURT_3),
			TileResources.Get(LIQUID_SPURT_4),
			TileResources.Get(LIQUID_SPURT_5),
		]);

		animations.set(EXPLOSION, [
			TileResources.Get(EXPLOSION_1),
			TileResources.Get(EXPLOSION_2),
			TileResources.Get(EXPLOSION_3),
			TileResources.Get(EXPLOSION_4),
			TileResources.Get(EXPLOSION_5),
		]);
	}
}
