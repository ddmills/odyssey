package domain.systems;

import core.Frame;

class SystemManager
{
	public var energy(default, null):EnergySystem;
	public var fuel(default, null):FuelSystem;
	public var movement(default, null):MovementSystem;
	public var chunks(default, null):ChunkSystem;
	public var sprites(default, null):SpriteSystem;
	public var lights(default, null):LightSystem;
	public var vision(default, null):VisionSystem;
	public var bitmasks(default, null):BitmaskSystem;
	public var death(default, null):DeathSystem;
	public var bullets(default, null):BulletSystem;
	public var path(default, null):PathFollowSystem;
	public var hitBlink(default, null):HitBlinkSystem;
	public var destroy(default, null):DestroySystem;

	public function new() {}

	public function initialize()
	{
		energy = new EnergySystem();
		fuel = new FuelSystem();
		bullets = new BulletSystem();
		movement = new MovementSystem();
		chunks = new ChunkSystem();
		path = new PathFollowSystem();
		sprites = new SpriteSystem();
		lights = new LightSystem();
		vision = new VisionSystem();
		bitmasks = new BitmaskSystem();
		death = new DeathSystem();
		hitBlink = new HitBlinkSystem();
		destroy = new DestroySystem();
	}

	public function update(frame:Frame)
	{
		death.update(frame);
		energy.update(frame);
		fuel.update(frame);
		chunks.update(frame);
		movement.update(frame);
		path.update(frame);
		lights.update(frame);
		vision.update(frame);
		bitmasks.update(frame);
		sprites.update(frame);
		bullets.update(frame);
		hitBlink.update(frame);
		destroy.update(frame);
	}
}
