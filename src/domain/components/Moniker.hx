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

		var base = baseName;

		if (stacks != null)
		{
			base += ' ${stacks.displayName}';
		}

		if (equipped != null)
		{
			base += ' ${equipped.slotDisplay}';
		}

		return base;
	}
}
