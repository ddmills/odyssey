package common.util;

import common.struct.Coordinate;
import core.Game;

enum Space
{
	SCREEN;
	PIXEL;
	WORLD;
	CHUNK;
	ZONE;
}

class Projection
{
	static var game(get, null):Game;
	static var chunkSize(get, null):Int;

	inline static function get_game():Game
	{
		return Game.instance;
	}

	inline static function get_chunkSize():Int
	{
		return game.world.chunkSize;
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

	public static function pxToChunk(px:Float, py:Float):Coordinate
	{
		var world = pxToWorld(px, py);
		return new Coordinate(world.x / chunkSize, world.y / chunkSize, CHUNK);
	}

	public static function pxToZone(px:Float, py:Float):Coordinate
	{
		var chunk = pxToChunk(px, py);
		return chunkToZone(chunk.x, chunk.y);
	}

	public static function chunkToPx(cx:Float, cy:Float):Coordinate
	{
		var world = chunkToWorld(cx, cy);
		return worldToPx(world.x, world.y);
	}

	public static function worldToChunk(wx:Float, wy:Float):Coordinate
	{
		return new Coordinate(Math.floor(wx / chunkSize), Math.floor(wy / chunkSize), CHUNK);
	}

	public static function worldToZone(wx:Float, wy:Float):Coordinate
	{
		var chunk = worldToChunk(wx, wy);
		return chunkToZone(chunk.x, chunk.y);
	}

	public static function chunkToWorld(cx:Float, cy:Float):Coordinate
	{
		return new Coordinate(cx * chunkSize, cy * chunkSize, WORLD);
	}

	public static function chunkToZone(cx:Float, cy:Float):Coordinate
	{
		var cs = Game.instance.world.chunksPerZone;
		return new Coordinate(cx / cs, cy / cs, ZONE);
	}

	public static function chunkToScreen(cx:Float, cy:Float):Coordinate
	{
		var px = chunkToPx(cx, cy);
		return pxToScreen(px.x, px.y);
	}

	public static function screenToChunk(sx:Float, sy:Float):Coordinate
	{
		var w = screenToWorld(sx, sy);
		return worldToChunk(w.x, w.y);
	}

	public static function screenToZone(sx:Float, sy:Float):Coordinate
	{
		var c = screenToChunk(sx, sy);
		return chunkToZone(c.x, c.y);
	}

	public static function zoneToChunk(zx:Float, zy:Float):Coordinate
	{
		var cs = Game.instance.world.chunksPerZone;
		return new Coordinate(zx * cs, zy * cs, CHUNK);
	}

	public static function zoneToWorld(zx:Float, zy:Float):Coordinate
	{
		var chunk = zoneToChunk(zx, zy);
		return chunkToWorld(chunk.x, chunk.y);
	}

	public static function zoneToPx(zx:Float, zy:Float):Coordinate
	{
		var chunk = zoneToChunk(zx, zy);
		return chunkToPx(chunk.x, chunk.y);
	}

	public static function zoneToScreen(zx:Float, zy:Float):Coordinate
	{
		var chunk = zoneToChunk(zx, zy);
		return chunkToScreen(chunk.x, chunk.y);
	}
}
