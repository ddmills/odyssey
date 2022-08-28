package domain;

import core.Game;
import domain.gen.MapGen;
import domain.systems.SystemManager;

class World
{
	public var game(get, null):Game;
	public var systems(default, null):SystemManager;
	public var clock(default, null):Clock;
	public var player(default, null):PlayerManager;
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
		player = new PlayerManager();
	}

	public function initialize()
	{
		systems.initialize();
		MapGen.Generate(1);
		player.initialize();
	}

	public function updateSystems()
	{
		systems.update(game.frame);
	}
}
