package data;

import h2d.Tile;

class TileResources
{
	public static var tiles:Map<TileKey, Tile> = [];

	public static function Get(key:TileKey):Tile
	{
		if (key == null)
		{
			return null;
		}
		return tiles.get(key);
	}

	public static function Init()
	{
		var t = hxd.Res.tiles.scroll;

		tiles.set(GRASS_1, t.grass_1.toTile());
		tiles.set(GRASS_2, t.grass_2.toTile());
		tiles.set(GRASS_3, t.grass_3.toTile());
		tiles.set(GRASS_4, t.grass_4.toTile());
		tiles.set(SNAKE_1, t.snake_1.toTile());
		tiles.set(CORPSE_SNAKE, t.snake_corpse.toTile());
		tiles.set(CORPSE_HUMAN, t.corpse_human.toTile());
		tiles.set(STICK_1, t.stick_1.toTile());
		tiles.set(HERO, t.hero.toTile());
		tiles.set(EYE_OPEN, t.eye.toTile());
		tiles.set(EYE_CLOSE, t.eye_closed.toTile());
		tiles.set(CURSOR, t.cursor.toTile());
		tiles.set(LIST_DASH, t.list_dash.toTile());
		tiles.set(LIST_ARROW, t.list_arrow.toTile());
		tiles.set(RIFLE, t.rifle.toTile());
		tiles.set(NAVY_REVOLVER, t.pistol.toTile());
		tiles.set(COACH_GUN, t.shotgun.toTile());
		tiles.set(PONCHO, t.poncho.toTile());
		tiles.set(DUSTER, t.duster.toTile());
		tiles.set(LONG_JOHNS, t.longjohns.toTile());
		tiles.set(BLOOD_SPATTER, t.blood_spatter_1.toTile());
		tiles.set(THUG_1, t.thug_1.toTile());
		tiles.set(THUG_2, t.thug_2.toTile());
		tiles.set(TEXT_CURSOR, t.text_cursor.toTile());

		var catus = hxd.Res.tiles.scroll.cacti.toTile().divide(4, 1);
		tiles.set(CACTUS_1, catus[0][0]);
		tiles.set(CACTUS_2, catus[0][1]);
		tiles.set(CACTUS_1_FLOWER, catus[0][2]);
		tiles.set(CACTUS_2_FLOWER, catus[0][3]);

		var arrows = hxd.Res.tiles.scroll.arrows.toTile().divide(3, 3);
		tiles.set(ARROW_NW, arrows[0][0]);
		tiles.set(ARROW_N, arrows[1][0]);
		tiles.set(ARROW_NE, arrows[2][0]);
		tiles.set(ARROW_W, arrows[0][1]);
		tiles.set(ARROW_E, arrows[2][1]);
		tiles.set(ARROW_SW, arrows[0][2]);
		tiles.set(ARROW_S, arrows[1][2]);
		tiles.set(ARROW_SE, arrows[2][2]);
		tiles.set(DOT, arrows[1][1]);

		var chestLg = t.chest_large.toTile().divide(2, 1);
		tiles.set(CHEST_LARGE_CLOSED, chestLg[0][0]);
		tiles.set(CHEST_LARGE_OPEN, chestLg[0][1]);

		var chestSm = t.chest_small.toTile().divide(2, 1);
		tiles.set(CHEST_SMALL_CLOSED, chestSm[0][0]);
		tiles.set(CHEST_SMALL_OPEN, chestSm[0][1]);

		var sands = t.sand.toTile().divide(4, 1);
		tiles.set(SAND_1, sands[0][0]);
		tiles.set(SAND_2, sands[0][1]);
		tiles.set(SAND_3, sands[0][2]);
		tiles.set(SAND_4, sands[0][3]);
	}
}
