package domain;

import core.Game;
import domain.AIManager;
import domain.gen.MapGen;
import domain.systems.SystemManager;

class World
{
	public var game(get, null):Game;
	public var systems(default, null):SystemManager;
	public var clock(default, null):Clock;
	public var ai(default, null):AIManager;
	public var player(default, null):PlayerManager;
	public var mapWidth(default, null):Int = 64;
	public var mapHeight(default, null):Int = 64;
	public var seed:Int = 123;

	inline function get_game():Game
	{
		return Game.instance;
	}

	public function new()
	{
		seed = 1234;
		systems = new SystemManager();

		clock = new Clock();
		ai = new AIManager();
		player = new PlayerManager();
	}

	public function initialize()
	{
		systems.initialize();
		MapGen.Generate(seed);
		player.initialize();
	}

	public function updateSystems()
	{
		systems.update(game.frame);
	}
}
