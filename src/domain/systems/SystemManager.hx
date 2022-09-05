package domain.systems;

import core.Frame;

class SystemManager
{
	public var energy(default, null):EnergySystem;
	public var movement(default, null):MovementSystem;
	public var sprites(default, null):SpriteSystem;
	public var vision(default, null):VisionSystem;
	public var death(default, null):DeathSystem;

	public function new() {}

	public function initialize()
	{
		energy = new EnergySystem();
		movement = new MovementSystem();
		sprites = new SpriteSystem();
		vision = new VisionSystem();
		death = new DeathSystem();
	}

	public function update(frame:Frame)
	{
		energy.update(frame);
		movement.update(frame);
		sprites.update(frame);
		vision.update(frame);
		death.update(frame);
	}
}
