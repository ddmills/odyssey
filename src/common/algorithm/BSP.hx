package common.algorithm;

import hxd.Rand;

typedef BspNode =
{
	var id:Int;
	var isLeaf:Bool;
	var parentId:Int;
	var siblingId:Int;
	var offsetX:Int;
	var offsetY:Int;
	var width:Int;
	var height:Int;
}

typedef BspSettings =
{
	?width:Int,
	?height:Int,
	?minNodeWidth:Int,
	?minNodeHeight:Int,
	?maxNodeWidth:Int,
	?maxNodeHeight:Int,
	?splitIgnoreChance:Float,
};

enum SplitDirection
{
	VERTICAL;
	HORIZONTAL;
}

class BSP
{
	public static function createGraph(r:Rand, settings:BspSettings):Array<BspNode>
	{
		var width = settings.width.or(50);
		var height = settings.height.or(50);
		var splitIgnoreChance = settings.splitIgnoreChance.or(.5);
		var minNodeWidth = settings.minNodeWidth.or(5);
		var minNodeHeight = settings.minNodeHeight.or(5);
		var maxNodeWidth = settings.maxNodeWidth.or(10);
		var maxNodeHeight = settings.maxNodeHeight.or(10);
		var nodes:Array<BspNode> = [];
		var graph:Array<BspNode> = [];
		var curId = 1;
		var idGen = () -> ++curId;

		nodes.push({
			id: idGen(),
			isLeaf: true,
			parentId: -1,
			siblingId: -1,
			offsetX: 0,
			offsetY: 0,
			width: width,
			height: height,
		});

		while (nodes.length > 0)
		{
			var node = nodes.pop();
			graph.push(node);

			if (node.width < maxNodeWidth && node.height < maxNodeHeight)
			{
				if (r.bool(splitIgnoreChance))
				{
					continue;
				}
			}

			var directions:Array<SplitDirection> = [];

			if (node.width - minNodeWidth > minNodeWidth)
			{
				directions.push(VERTICAL);
			}

			if (node.height - minNodeHeight > minNodeHeight)
			{
				directions.push(HORIZONTAL);
			}

			if (directions.length <= 0)
			{
				continue;
			}

			var direction = r.pick(directions);

			if (direction == VERTICAL)
			{
				var cut = r.integer(minNodeWidth, node.width - minNodeWidth);
				var splits = splitNodeVertical(node, cut, idGen);
				nodes.push(splits.left);
				nodes.push(splits.right);
			}
			else
			{
				var cut = r.integer(minNodeHeight, node.height - minNodeHeight);
				var splits = splitNodeHorizontal(node, cut, idGen);
				nodes.push(splits.top);
				nodes.push(splits.bottom);
			}

			node.isLeaf = false;
		}

		return graph;
	}

	private static function splitNodeVertical(node:BspNode, cut:Int, idGen:() -> Int):{left:BspNode, right:BspNode}
	{
		var leftId = idGen();
		var rightId = idGen();
		return {
			left: {
				id: leftId,
				isLeaf: true,
				parentId: node.id,
				siblingId: rightId,
				offsetX: node.offsetX,
				offsetY: node.offsetY,
				width: cut,
				height: node.height,
			},
			right: {
				id: rightId,
				isLeaf: true,
				parentId: node.id,
				siblingId: leftId,
				offsetX: node.offsetX + cut,
				offsetY: node.offsetY,
				width: node.width - cut,
				height: node.height,
			}
		}
	}

	private static function splitNodeHorizontal(node:BspNode, cut:Int, idGen:() -> Int):{top:BspNode, bottom:BspNode}
	{
		var topId = idGen();
		var bottomId = idGen();
		return {
			top: {
				id: topId,
				isLeaf: true,
				parentId: node.id,
				siblingId: bottomId,
				offsetX: node.offsetX,
				offsetY: node.offsetY,
				width: node.width,
				height: cut,
			},
			bottom: {
				id: bottomId,
				isLeaf: true,
				parentId: node.id,
				siblingId: topId,
				offsetX: node.offsetX,
				offsetY: node.offsetY + cut,
				width: node.width,
				height: node.height - cut,
			}
		}
	}
}
