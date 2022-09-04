package domain.prefabs;

import ecs.Entity;
import hxd.Rand;

abstract class Prefab
{
	public function new() {};

	public abstract function Create(?options:Dynamic):Entity;
}
