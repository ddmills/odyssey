package domain.systems;

import core.Frame;

class SystemManager
{
	public var sprites(default, null):SpriteSystem;

	public function new() {}

	public function initialize()
	{
		sprites = new SpriteSystem();
	}

	public function update(frame:Frame)
	{
		sprites.update(frame);
	}
}
