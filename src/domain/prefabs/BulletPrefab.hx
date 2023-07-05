package domain.prefabs;

import data.ColorKey;
import domain.components.Bullet;
import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;

class BulletPrefab extends Prefab
{
	public function Create(options:Dynamic):Entity
	{
		var bullet = new Entity();
		bullet.add(new Sprite(DOT, C_GRAY_2, C_GRAY_2, OVERLAY));
		bullet.add(new Moniker('Bullet'));
		bullet.add(new Bullet());
		return bullet;
	}
}
