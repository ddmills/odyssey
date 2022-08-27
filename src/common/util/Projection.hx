package common.util;

import common.struct.Coordinate;
import core.Game;

enum Space
{
	PIXEL;
	WORLD;
	SCREEN;
}

class Projection
{
	static var game(get, null):Game;

	inline static function get_game():Game
	{
		return Game.instance;
	}

	public static function worldToPx(wx:Float, wy:Float):Coordinate
	{
		return new Coordinate(wx * game.TILE_W, wy * game.TILE_H, PIXEL);
	}

	public static function pxToWorld(px:Float, py:Float):Coordinate
	{
		return new Coordinate(px / game.TILE_W, py / game.TILE_H, WORLD);
	}

	public static function screenToPx(sx:Float, sy:Float):Coordinate
	{
		var camWorld = worldToPx(game.camera.x, game.camera.y);
		var px = (sx + camWorld.x) / game.camera.zoom;
		var py = (sy + camWorld.y) / game.camera.zoom;
		return new Coordinate(px, py, PIXEL);
	}

	public static function pxToScreen(px:Float, py:Float):Coordinate
	{
		var camWorld = worldToPx(game.camera.x, game.camera.y);
		var sx = (px * game.camera.zoom) - camWorld.x;
		var sy = (py * game.camera.zoom) - camWorld.y;

		return new Coordinate(sx, sy, SCREEN);
	}

	public static function screenToWorld(sx:Float, sy:Float):Coordinate
	{
		var p = screenToPx(sx, sy);
		return pxToWorld(p.x, p.y);
	}

	public static function worldToScreen(wx:Float, wy:Float):Coordinate
	{
		var px = worldToPx(wx, wy);
		return pxToScreen(px.x, px.y);
	}
}
