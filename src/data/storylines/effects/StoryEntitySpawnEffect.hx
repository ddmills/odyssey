package data.storylines.effects;

import common.struct.Coordinate;
import core.Game;
import data.SpawnableType;
import domain.prefabs.Spawner;
import haxe.EnumTools;

typedef StoryEntitySpawnEffectParams =
{
	spawnable:SpawnableType,
	store:String,
	zone:String,
}

class StoryEntitySpawnEffect extends StoryEffect
{
	private var params:StoryEntitySpawnEffectParams;

	public function new(params:StoryEntitySpawnEffectParams)
	{
		super();
		this.params = params;
	}

	public function apply(storyline:Storyline)
	{
		var pos = Game.instance.world.player.pos.floor().add(new Coordinate(0, -10, WORLD));

		if (params.zone != null)
		{
			var zone = storyline.getZoneVariable(params.zone);
			pos = zone.worldPos.add(25, 25).asWorld();
			trace('spawned in ${zone.zonePos.toString()} - ${pos.toString()}');
		}

		var entity = Spawner.Spawn(params.spawnable, pos, {}, true);

		storyline.setEntityVariable(params.store, entity);
	}

	public static function FromJson(json:Dynamic):StoryEntitySpawnEffect
	{
		var spawnable = EnumTools.createByName(SpawnableType, json.spawnable);

		return new StoryEntitySpawnEffect({
			spawnable: spawnable,
			store: json.store,
			zone: json.zone,
		});
	}
}
