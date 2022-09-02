package core;

import data.input.InputDomainType;
import screens.EmptyScreen;

class ScreenManager
{
	var screens:Array<Screen>;

	public var current(get, null):Screen;
	public var previous(get, null):Screen;
	public var domain(get, null):InputDomainType;
	public var stack(get, null):Array<Screen>;

	inline function get_current():Screen
	{
		return screens[screens.length - 1];
	}

	inline function get_previous():Screen
	{
		return screens[screens.length - 2];
	}

	public function new()
	{
		screens = new Array();
		screens.push(new EmptyScreen());
	}

	public function set(screen:Screen)
	{
		while (screens.length > 0)
		{
			current.onDestroy();
			screens.pop();
		}

		Game.instance.input.flush();
		screens.push(screen);
		current.onEnter();
	}

	public function replace(screen:Screen)
	{
		current.onDestroy();
		screens.pop();
		screens.push(screen);
		current.onEnter();
	}

	public function push(screen:Screen)
	{
		current.onSuspend();
		screens.push(screen);
		current.onEnter();
	}

	public function pop()
	{
		current.onDestroy();
		screens.pop();
		current.onResume();
	}

	function get_domain():InputDomainType
	{
		return current.inputDomain;
	}

	function get_stack():Array<Screen>
	{
		return screens.copy();
	}
}
