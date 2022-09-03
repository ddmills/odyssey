package core;

import common.struct.Coordinate;
import core.input.KeyCode;
import data.input.InputDomainType;
import domain.World;

class Screen
{
	public var game(get, null):Game;
	public var world(get, null):World;
	public var camera(get, null):Camera;

	public var onClosedlistener:() -> Void = () -> {};

	public var inputDomain:InputDomainType = INPUT_DOMAIN_DEFAULT;

	inline function get_game():Game
	{
		return Game.instance;
	}

	inline function get_world():World
	{
		return Game.instance.world;
	}

	inline function get_camera():Camera
	{
		return Game.instance.camera;
	}

	/**
	 * Called after the game successfully enters this screen.
	 * Use for resource setup.
	 */
	@:allow(core.ScreenManager)
	function onEnter() {}

	/**
	 * Called after the game leaves this screen.
	 * Use for resource cleanup.
	 */
	@:allow(core.ScreenManager)
	function onDestroy() {}

	/**
	 * Called when the game temporarily leaves this screen.
	 */
	@:allow(core.ScreenManager)
	function onSuspend() {}

	/**
	 * Called when the game resumes this screen. (opposite of suspend)
	 */
	@:allow(core.ScreenManager)
	function onResume() {}

	/**
	 * Called on every frame.
	 */
	@:allow(core.Game)
	function update(frame:Frame) {}

	/**
	 * Handle mouse click down
	 */
	@:allow(core.input.InputManager)
	function onMouseDown(pos:Coordinate) {}

	/**
	 * Handle mouse click up
	 */
	@:allow(core.input.InputManager)
	function onMouseUp(pos:Coordinate) {}

	/**
	 * Handle mouse moved
	 */
	@:allow(core.input.InputManager)
	function onMouseMove(pos:Coordinate, previous:Coordinate) {}

	/**
	 * Handle key up
	 */
	@:allow(core.input.InputManager)
	function onKeyDown(key:KeyCode) {}
}
