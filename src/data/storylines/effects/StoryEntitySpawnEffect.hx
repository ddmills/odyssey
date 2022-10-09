package data.storylines.effects;

import common.struct.Coordinate;
import core.Game;
import data.SpawnableType;
import domain.prefabs.Spawner;
import haxe.EnumTools;

typedef StoryEntitySpawnEffectParams =
{
	var spawnable:SpawnableType;
	var store:String;
}

class StoryEntitySpawnEffect extends StoryEffect
{
	private var params:StoryEntitySpawnEffectParams;

	public function new(params:StoryEntitySpawnEffectParams)
	{
		super();
		this.params = params;
	}

	public override function apply(storyline:Storyline)
	{
		var pos = Game.instance.world.player.pos.floor().add(new Coordinate(0, -10, WORLD));
		trace('SPAWN AT', pos.toString());

		var entity = Spawner.Spawn(params.spawnable, pos, {}, true);

		storyline.setEntityVariable(params.store, entity);
	}

	public static function FromJson(json:Dynamic):StoryEntitySpawnEffect
	{
		var spawnable = EnumTools.createByName(SpawnableType, json.spawnable);

		return new StoryEntitySpawnEffect({
			spawnable: spawnable,
			store: json.store,
		});
	}
}
