package domain.systems;

import core.Frame;

class SystemManager
{
	public var energy(default, null):EnergySystem;
	public var movement(default, null):MovementSystem;
	public var sprites(default, null):SpriteSystem;

	public function new() {}

	public function initialize()
	{
		energy = new EnergySystem();
		movement = new MovementSystem();
		sprites = new SpriteSystem();
	}

	public function update(frame:Frame)
	{
		energy.update(frame);
		movement.update(frame);
		sprites.update(frame);
	}
}
