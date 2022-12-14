package domain.components;

import domain.events.EnemyKilledEvent;
import domain.events.LevelUpEvent;
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

		xp += GameMath.GetXpGain(level, evt.enemy.get(Level).level);
	}

	function levelUp()
	{
		level++;
		entity.fireEvent(new LevelUpEvent(level));
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
