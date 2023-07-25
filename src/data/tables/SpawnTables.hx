package data.tables;

import common.struct.WeightedTable;

class SpawnTables
{
	public static var tables:Map<SpawnTableType, WeightedTable<SpawnableType>> = [];

	public static function Get(key:SpawnTableType):WeightedTable<SpawnableType>
	{
		if (key.isNull())
		{
			return null;
		}

		var table = tables.get(key);

		if (table.isNull())
		{
			trace('Spawnable Table Type not found "${key}"');
		}

		return table;
	}

	public static function Init()
	{
		var treeDestructTable = new WeightedTable<SpawnableType>();
		treeDestructTable.add(null, 25);
		treeDestructTable.add(ASHES, 15);
		treeDestructTable.add(STICK, 25);
		treeDestructTable.add(LOG, 50);

		tables.set(TBL_SPWN_TREE_DESTRUCT, treeDestructTable);

		var woodDestructTable = new WeightedTable<SpawnableType>();
		woodDestructTable.add(null, 25);
		woodDestructTable.add(ASHES, 25);
		woodDestructTable.add(WOOD_PLANK, 50);

		tables.set(TBL_SPWN_WOOD_DESTRUCT, woodDestructTable);
	}
}
