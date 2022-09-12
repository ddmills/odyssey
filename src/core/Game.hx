package core;

import core.input.CommandManager;
import core.input.InputManager;
import core.rendering.RenderLayerManager;
import data.TextResources;
import domain.World;
import ecs.Registry;
import h2d.Console;
import hxd.Window;

class Game
{
	public var DIE_SIZE:Int = 12;
	public var TILE_W:Int = 16;
	public var TILE_H:Int = 16;

	public var TILE_W_HALF(get, never):Int;
	public var TILE_H_HALF(get, never):Int;
	public var CLEAR_COLOR:Int = 0x111113;
	public var TEXT_COLOR:Int = 0xE2EAEC;
	public var TEXT_COLOR_FOCUS:Int = 0xfff455;

	public static var instance:Game;

	public var backgroundColor(get, set):Int;
	public var frame(default, null):Frame;
	public var app(default, null):hxd.App;
	public var camera(default, null):Camera;
	public var window(get, never):hxd.Window;
	public var screens(default, null):ScreenManager;
	public var audio(default, null):AudioManager;
	public var input(default, null):InputManager;
	public var commands(default, null):CommandManager;
	public var console(default, null):Console;
	public var layers(default, null):RenderLayerManager;
	public var registry(default, null):Registry;
	public var world(default, null):World;

	private function new(app:hxd.App)
	{
		instance = this;
		this.app = app;

		frame = new Frame();
		screens = new ScreenManager();
		audio = new AudioManager();
		layers = new RenderLayerManager();
		camera = new Camera();
		input = new InputManager();
		commands = new CommandManager();
		console = new Console(TextResources.BIZCAT);
		registry = new Registry();
		world = new World();

		ConsoleConfig.Config(console);

		app.s2d.addChild(layers.root);
	}

	public static function Create(app:hxd.App)
	{
		if (instance != null)
		{
			return instance;
		}

		return new Game(app);
	}

	public inline function update()
	{
		frame.update();
		screens.current.update(frame);
	}

	public inline function render(layer:RenderLayerType, ob:h2d.Object)
	{
		return layers.render(layer, ob);
	}

	public inline function clear(layer:RenderLayerType)
	{
		return layers.clear(layer);
	}

	public function mount()
	{
		layers.clearAll();
		frame = new Frame();
	}

	function get_backgroundColor():Int
	{
		return app.engine.backgroundColor;
	}

	function set_backgroundColor(value:Int):Int
	{
		return app.engine.backgroundColor = value;
	}

	inline function get_window():Window
	{
		return hxd.Window.getInstance();
	}

	function get_TILE_W_HALF():Int
	{
		return Math.floor(TILE_W / 2);
	}

	function get_TILE_H_HALF():Int
	{
		return Math.floor(TILE_H / 2);
	}
}
