package domain.components;

import ecs.Component;

class Moniker extends Component
{
	@save public var baseName = 'Hello world';

	public var displayName(get, never):String;

	public function new(baseName:String)
	{
		this.baseName = baseName;
	}

	function get_displayName():String
	{
		var equipped = entity.get(IsEquipped);
		var stacks = entity.get(Stackable);

		var name = baseName;

		if (stacks != null && stacks.displayName.length > 0)
		{
			name += ' ${stacks.displayName}';
		}

		if (equipped != null && equipped.slotDisplay.length > 0)
		{
			name += ' ${equipped.slotDisplay}';
		}

		return name;
	}
}
