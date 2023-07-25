package domain.components;

import core.Game;
import data.AudioKey;
import data.tables.SpawnTableType;
import data.tables.SpawnTables;
import domain.events.AttackedEvent;
import domain.prefabs.Spawner;
import ecs.Component;

class Destructable extends Component
{
	@save public var spawnTableType:SpawnTableType;
	@save public var destructionAudio:AudioKey;

	public function new(spawnTableType:SpawnTableType = null, destructionAudio:AudioKey = null)
	{
		this.spawnTableType = spawnTableType;
		this.destructionAudio = destructionAudio;
		addHandler(AttackedEvent, onAttackedEvent);
	}

	public function onAttackedEvent(evt:AttackedEvent)
	{
		if (evt.attack.damageType == DMG_EXPLOSIVE)
		{
			if (!destructionAudio.isNull())
			{
				Game.instance.world.playAudio(entity.pos.toIntPoint(), destructionAudio);
			}

			if (!spawnTableType.isNull())
			{
				var type = SpawnTables.Get(spawnTableType).pick(Game.instance.world.rand);
				if (!type.isNull())
				{
					Spawner.Spawn(type, entity.pos);
				}
			}

			entity.add(new IsDestroyed());
		}
	}
}
