package domain.systems;

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
			world.chunks.loadChunks(e.pos.toChunkIdx());
		});
	}
}
