package domain.prefabs;

import ecs.Entity;

abstract class Prefab
{
	public function new() {};

	public abstract function Create(?options:Dynamic):Entity;
}
