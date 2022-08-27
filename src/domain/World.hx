package domain;

import core.Game;
import domain.gen.MapGen;
import domain.systems.SpriteSystem;
import domain.systems.SystemManager;

class World
{
	public var game(get, null):Game;
	public var systems(default, null):SystemManager;
	public var clock(default, null):Clock;
	public var mapWidth(default, null):Int = 64;
	public var mapHeight(default, null):Int = 64;

	inline function get_game():Game
	{
		return Game.instance;
	}

	public function new()
	{
		systems = new SystemManager();
		clock = new Clock();
	}

	public function initialize()
	{
		systems.initialize();
		MapGen.Generate(1);
	}

	public function updateSystems()
	{
		systems.update(game.frame);
	}
}
