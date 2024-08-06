package domain.components;

import data.ColorKey;
import domain.events.EnemyKilledEvent;
import domain.events.LevelUpEvent;
import domain.prefabs.Spawner;
import ecs.Component;

class Level extends Component
{
	@save public var xp(default, set):Int = 0;
	@save public var level:Int = 0;

	public var nextLevelXpReq(get, never):Int;

	public function new(current:Int = 0)
	{
		level = current;
		addHandler(EnemyKilledEvent, onEnemyKilled);
	}

	function onEnemyKilled(evt:EnemyKilledEvent)
	{
		if (!evt.enemy.has(Level))
		{
			trace('enemy has no level');
			return;
		}

		var gain = GameMath.GetXpGain(level, evt.enemy.get(Level).level);

		xp += gain;

		Spawner.Spawn(FLOATING_TEXT, entity.pos, {
			text: '+${gain}xp',
			color: ColorKey.C_GRAY,
			duration: 80
		});
	}

	function levelUp()
	{
		level++;
		entity.fireEvent(new LevelUpEvent(level));

		Spawner.Spawn(FLOATING_TEXT, entity.pos, {
			text: 'LEVEL UP',
			color: ColorKey.C_BLUE,
			duration: 300
		});
	}

	function set_xp(value:Int):Int
	{
		xp = value;
		while (xp >= nextLevelXpReq)
		{
			xp -= nextLevelXpReq;
			levelUp();
		}

		return xp;
	}

	function get_nextLevelXpReq():Int
	{
		return GameMath.GetLevelXpReq(level + 1);
	}
}
