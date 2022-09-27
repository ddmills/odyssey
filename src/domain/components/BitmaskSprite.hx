package domain.components;

import data.BitmaskType;
import data.Bitmasks;
import ecs.Component;

class BitmaskSprite extends Component
{
	@save public var bitmaskTypes:Array<BitmaskType>;
	@save public var overwriteTile:Bool;

	public var bitmaskType(get, never):BitmaskType;
	public var bitmask(get, never):BitmaskData;

	public function new(bitmaskTypes:Array<BitmaskType>, overwriteTile:Bool = true)
	{
		this.bitmaskTypes = bitmaskTypes;
		this.overwriteTile = overwriteTile;
	}

	inline function get_bitmask():BitmaskData
	{
		return Bitmasks.Get(bitmaskType);
	}

	inline function get_bitmaskType():BitmaskType
	{
		return bitmaskTypes[0];
	}
}
