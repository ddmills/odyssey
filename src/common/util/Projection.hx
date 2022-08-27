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
		var camPix = worldToPx(game.camera.x, game.camera.y);
		var px = camPix.x + (sx / game.camera.zoom);
		var py = camPix.y + (sy / game.camera.zoom);
		return new Coordinate(px, py, PIXEL);
	}

	public static function pxToScreen(px:Float, py:Float):Coordinate
	{
		var camPix = worldToPx(game.camera.x, game.camera.y);
		var sx = (px - camPix.x) * game.camera.zoom;
		var sy = (py - camPix.y) * game.camera.zoom;
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
