package domain.terrain.biomes;

import common.rand.Perlin;
import common.struct.IntPoint;
import common.struct.WeightedTable;
import data.BiomeType;
import data.ColorKey;
import data.PoiLayoutType;
import data.PoiType;
import data.SpawnableType;
import data.TileKey;
import domain.terrain.Cell;
import domain.terrain.gen.ZonePoi.PoiSize;
import domain.terrain.gen.pois.PoiDefinition;
import hxd.Rand;

typedef MapIconData =
{
	primary:ColorKey,
	secondary:ColorKey,
	background:ColorKey,
	tileKey:TileKey,
}

typedef RockData =
{
	primary:ColorKey,
	secondary:ColorKey,
}

class Biome
{
	public var seed:Int;
	public var type(default, null):BiomeType;
	public var creatures:WeightedTable<SpawnableType>;
	public var majorPois:WeightedTable<PoiDefinition>;
	public var mediumPois:WeightedTable<PoiDefinition>;
	public var minorPois:WeightedTable<PoiDefinition>;
	public var clearColor:Int;

	var r:Rand;
	var perlin:Perlin;

	public function new(seed:Int, type:BiomeType, clearColor:Int = 0x191D31)
	{
		this.seed = seed;
		this.type = type;
		this.clearColor = clearColor;

		r = new Rand(seed);
		perlin = new Perlin(seed);
		creatures = setupCreatures();
		majorPois = setupMajorPois();
		mediumPois = setupMediumPois();
		minorPois = setupMinorPois();
	}

	public function getMapIcon():MapIconData
	{
		return {
			primary: ColorKey.C_GREEN,
			secondary: ColorKey.C_WHITE,
			background: ColorKey.C_PURPLE,
			tileKey: TileKey.OVERWORLD_FOREST_1,
		}
	}

	public function getCommonRock():RockData
	{
		return {
			primary: C_STONE,
			secondary: C_CLEAR,
		};
	}

	function setupCreatures():WeightedTable<SpawnableType>
	{
		var e = new WeightedTable<SpawnableType>();

		e.add(SNAKE, 1);
		e.add(WOLF, 1);
		e.add(THUG, 1);
		e.add(THUG_2, 1);
		e.add(BAT, 1);
		e.add(BROWN_BEAR, 1);
		e.add(SCORPION, 1);
		return e;
	}

	function setupMajorPois():WeightedTable<PoiDefinition>
	{
		var p = new WeightedTable<PoiDefinition>();

		var town:PoiDefinition = {
			name: "Town",
			type: PoiType.POI_TOWN,
			layout: PoiLayoutType.POI_LAYOUT_SCATTERED,
			size: POI_SZ_MAJOR,
			rooms: [],
			icon: {
				primary: ColorKey.C_BROWN,
				secondary: ColorKey.C_WHITE,
				background: ColorKey.C_PURPLE,
				tileKey: TileKey.OVERWORLD_TOWN,
			}
		};

		var fort:PoiDefinition = {
			name: "Fort",
			type: PoiType.POI_FORT,
			layout: PoiLayoutType.POI_LAYOUT_FORTRESS,
			size: POI_SZ_MAJOR,
			rooms: [],
			icon: {
				primary: ColorKey.C_YELLOW,
				secondary: ColorKey.C_WHITE,
				background: ColorKey.C_PURPLE,
				tileKey: TileKey.OVERWORLD_FORT,
			}
		};

		p.add(town, 2);
		p.add(fort, 2);

		return p;
	}

	function setupMediumPois():WeightedTable<PoiDefinition>
	{
		var p = new WeightedTable<PoiDefinition>();

		var ruins:PoiDefinition = {
			name: "Ancient ruins",
			type: PoiType.POI_RUINS,
			layout: PoiLayoutType.POI_LAYOUT_RUINS,
			size: POI_SZ_MEDIUM,
			rooms: [],
			icon: {
				primary: ColorKey.C_BLUE,
				secondary: ColorKey.C_WHITE,
				background: ColorKey.C_PURPLE,
				tileKey: TileKey.OVERWORLD_RUINS,
			}
		};

		var trading:PoiDefinition = {
			name: "Trading Post",
			type: PoiType.POI_TRADE_POST,
			layout: PoiLayoutType.POI_LAYOUT_BASIC_SQUARE,
			size: POI_SZ_MEDIUM,
			rooms: [
				{
					type: ROOM_RAILROAD_STATION
				}
			],
			icon: {
				primary: ColorKey.C_WHITE,
				secondary: ColorKey.C_RED,
				background: ColorKey.C_PURPLE,
				tileKey: TileKey.OVERWORLD_TRADE,
			}
		};

		p.add(trading, 2);
		p.add(ruins, 2);

		return p;
	}

	function setupMinorPois():WeightedTable<PoiDefinition>
	{
		var p = new WeightedTable<PoiDefinition>();

		var banditCamp:PoiDefinition = {
			name: "Bandit camp",
			type: PoiType.POI_BANDIT_CAMP,
			layout: PoiLayoutType.POI_LAYOUT_BASIC_SQUARE,
			size: POI_SZ_MINOR,
			rooms: [
				{
					type: ROOM_CAMP
				}
			],
			icon: {
				primary: ColorKey.C_ORANGE,
				secondary: ColorKey.C_WHITE,
				background: ColorKey.C_PURPLE,
				tileKey: TileKey.OVERWORLD_DOT,
			}
		};

		var graveyard:PoiDefinition = {
			name: "Graveyard",
			type: PoiType.POI_GRAVEYARD_SMALL,
			layout: PoiLayoutType.POI_LAYOUT_BASIC_SQUARE,
			size: POI_SZ_MINOR,
			rooms: [
				{
					type: ROOM_GRAVEYARD
				}
			],
			icon: {
				primary: ColorKey.C_GRAY,
				secondary: ColorKey.C_WHITE,
				background: ColorKey.C_PURPLE,
				tileKey: TileKey.OVERWORLD_DOT,
			}
		};

		p.add(banditCamp, 2);
		p.add(graveyard, 2);

		return p;
	}

	public function getPoi(size:PoiSize, r:Rand):PoiDefinition
	{
		return switch size
		{
			case POI_SZ_MAJOR: majorPois.pick(r);
			case POI_SZ_MEDIUM: mediumPois.pick(r);
			case POI_SZ_MINOR: minorPois.pick(r);
			case _: minorPois.pick(r);
		}
	}

	public function setCellData(pos:IntPoint, cell:Cell)
	{
		cell.terrain = TerrainType.TERRAIN_GRASS;
		cell.tileKey = GRASS_V1_1;
		cell.primary = C_DARK_GREEN;
		cell.background = C_DARK_GREEN;
	}

	public function spawnEntity(pos:IntPoint, cell:Cell) {}
}
