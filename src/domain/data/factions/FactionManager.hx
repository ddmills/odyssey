package domain.data.factions;

import data.FactionType;
import domain.components.FactionMember;
import ecs.Entity;
import haxe.EnumTools.EnumValueTools;

typedef FactionManagerSave =
{
	relations:Map<String, Int>,
}

class FactionManager
{
	private var relations:Map<String, Int>;
	private var hostileThreshold = -200;

	public function new()
	{
		relations = new Map();
	}

	public function initialize()
	{
		relations = new Map();

		setRelation(FACTION_PLAYER, FACTION_BANDIT, -400);
		setRelation(FACTION_PLAYER, FACTION_VILLAGE, 250);
		setRelation(FACTION_PLAYER, FACTION_WILDLIFE, -250);
		setRelation(FACTION_VILLAGE, FACTION_BANDIT, -400);
		setRelation(FACTION_VILLAGE, FACTION_WILDLIFE, -100);
	}

	public function save():FactionManagerSave
	{
		return {
			relations: relations,
		};
	}

	public function load(data:FactionManagerSave)
	{
		relations = data.relations;
	}

	public function getEntityRelation(a:Entity, b:Entity):Int
	{
		var memberA = a.get(FactionMember);
		var memberB = b.get(FactionMember);

		if (memberA != null && memberB != null)
		{
			return getRelation(memberA.factionType, memberB.factionType);
		}

		return 0;
	}

	public function areEntitiesHostile(a:Entity, b:Entity):Bool
	{
		var relation = getEntityRelation(a, b);

		return relation < hostileThreshold;
	}

	public function getRelation(a:FactionType, b:FactionType):Int
	{
		var key = getRelationKey(a, b);
		var relation = relations.get(key);

		return relation.or(0);
	}

	public function setRelation(a:FactionType, b:FactionType, value:Int)
	{
		var key = getRelationKey(a, b);
		relations.set(key, value);
	}

	private function getRelationKey(a:FactionType, b:FactionType):String
	{
		var k1 = EnumValueTools.getName(a);
		var k2 = EnumValueTools.getName(b);
		var keys = [k1, k2];

		keys.sort((s1, s2) -> s1 > s2 ? 1 : -1);

		return keys.join('-');
	}
}
