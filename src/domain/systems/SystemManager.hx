package domain.systems;

import core.Frame;

class SystemManager
{
	public var energy(default, null):EnergySystem;
	public var movement(default, null):MovementSystem;
	public var chunks(default, null):ChunkSystem;
	public var sprites(default, null):SpriteSystem;
	public var vision(default, null):VisionSystem;
	public var death(default, null):DeathSystem;
	public var bullets(default, null):BulletSystem;
	public var path(default, null):PathFollowSystem;

	public function new() {}

	public function initialize()
	{
		energy = new EnergySystem();
		bullets = new BulletSystem();
		movement = new MovementSystem();
		chunks = new ChunkSystem();
		path = new PathFollowSystem();
		sprites = new SpriteSystem();
		vision = new VisionSystem();
		death = new DeathSystem();
	}

	public function update(frame:Frame)
	{
		death.update(frame);
		energy.update(frame);
		movement.update(frame);
		chunks.update(frame);
		path.update(frame);
		vision.update(frame);
		sprites.update(frame);
		bullets.update(frame);
	}
}
