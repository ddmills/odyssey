package domain.components;

import ecs.Component;

class Moniker extends Component
{
	public var baseName = 'Hello world';

	public var displayName(get, never):String;

	public function new(baseName:String)
	{
		this.baseName = baseName;
	}

	function get_displayName():String
	{
		var equipped = entity.get(IsEquipped);

		if (equipped != null)
		{
			return '$baseName ${equipped.slotDisplay}';
		}

		return baseName;
	}
}
