package domain.prefabs.decorators;

import data.FactionType;
import data.SpawnableType;
import domain.ai.BehaviourType;
import domain.components.Actor;
import domain.components.Attributes;
import domain.components.Energy;
import domain.components.FactionMember;
import domain.components.Health;
import domain.components.IsCreature;
import domain.components.Level;
import domain.components.Moniker;
import domain.components.Vision;
import ecs.Entity;

typedef CharacterOptions =
{
	?moniker:Null<String>,
	?level:Null<Int>,
	?grit:Null<Int>,
	?savvy:Null<Int>,
	?finesse:Null<Int>,
	?faction:Null<FactionType>,
	?corpse:Null<SpawnableType>,
	?energy:Null<Int>,
	?behaviour:Null<BehaviourType>,
}

class BasicCharacterDecorator
{
	public static function Decorate(entity:Entity, options:CharacterOptions)
	{
		entity.add(new Moniker(options.moniker.or('Unknown')));
		entity.add(new Vision(12));
		entity.add(new Energy(options.energy.or(-10)));
		entity.add(new Actor(BHV_BASIC));
		entity.add(new Level(options.level ?? 1));
		entity.add(new IsCreature());
		entity.add(new Attributes(options.grit ?? 0, options.savvy ?? 0, options.finesse ?? 0));
		entity.add(new FactionMember(options.faction ?? FACTION_VILLAGE));

		entity.add(new Health());
		entity.get(Health).corpsePrefab = options.corpse;
	}
}
