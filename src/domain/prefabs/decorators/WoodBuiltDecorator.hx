package domain.prefabs.decorators;

import domain.components.Destructable;
import ecs.Entity;

class WoodBuiltDecorator
{
	public static function Decorate(entity:Entity)
	{
		entity.add(new Destructable(TBL_SPWN_WOOD_DESTRUCT, WOOD_DESTROY_1));
	}
}
