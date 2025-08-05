package domain.systems;

import core.Frame;
import domain.components.IsPlayer;
import domain.components.Moved;
import ecs.Query;
import ecs.System;

class ChunkSystem extends System
{
	public function new()
	{
		var q = new Query({
			all: [IsPlayer, Moved],
		});

		q.onEntityAdded((e) ->
		{
			if (!world.map.realms.hasActiveRealm)
			{
				world.map.chunks.loadChunks(e.pos.toChunkIdx());
			}
		});
	}

	override function update(frame:Frame)
	{
		world.map.chunks.update();
	}
}
