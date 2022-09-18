package domain.components;

import data.SpawnableType;
import domain.events.FuelDepletedEvent;
import domain.prefabs.Spawner;
import ecs.Component;

class Combustible extends Component
{
	@save public var productPrefab:SpawnableType;

	public function new(productPrefab:SpawnableType)
	{
		this.productPrefab = productPrefab;
		addHandler(FuelDepletedEvent, (evt) -> onFuelDepleted(cast evt));
	}

	public function onFuelDepleted(evt:FuelDepletedEvent)
	{
		trace('FUEL DEPLETED!');
		entity.add(new IsDestroyed());
		if (productPrefab != null)
		{
			Spawner.Spawn(productPrefab, entity.pos);
		}
	}
}
