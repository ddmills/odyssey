package domain.terrain;

import common.struct.IntPoint;
import core.Game;
import hxd.Pixels;
import hxd.res.Image;

class MapWeight
{
	var pixels:Pixels;

	public function new(image:Image)
	{
		pixels = image.getPixels(BGRA);
	}

	function worldToPx(p:IntPoint):IntPoint
	{
		var scaleX = Game.instance.world.mapWidth;
		var scaleY = Game.instance.world.mapHeight;

		var x = ((p.x / scaleX) * pixels.width).floor();
		var y = ((p.y / scaleY) * pixels.height).floor();

		return new IntPoint(x, y);
	}

	public function getWeight(w:IntPoint):Float
	{
		var pos = worldToPx(w);
		var pixel = -1 * pixels.getPixel(pos.x, pos.y);

		var white = 0xffffff;

		return pixel / white;
	}
}
