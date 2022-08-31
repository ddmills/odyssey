package screens.cursor.renderer;

import core.Frame;
import core.Game;
import domain.World;
import screens.cursor.CursorScreen.CursorRenderOpts;

class CursorRenderer
{
	public var game(get, null):Game;
	public var world(get, null):World;

	inline function get_game():Game
	{
		return Game.instance;
	}

	inline function get_world():World
	{
		return Game.instance.world;
	}

	public function render(opts:CursorRenderOpts) {}

	public function cleanup() {}

	public function update(frame:Frame) {}
}
