package core.rendering;

import core.rendering.RenderLayer.RenderLayerSpace;
import h2d.Bitmap;
import h2d.Layers;
import h2d.Tile;
import shaders.SpriteShader;

enum RenderLayerType
{
	BACKGROUND;
	GROUND;
	OBJECTS;
	ACTORS;
	OVERLAY;
	HUD;
	POPUP;
}

class RenderLayerManager
{
	public var root(default, null):Layers;
	public var scroller(default, null):Layers;
	public var screen(default, null):Layers;

	private var scrollerCount:Int = 0;
	private var screenCount:Int = 0;
	private var layers:Map<RenderLayerType, RenderLayer>;

	public function new()
	{
		var bkg = new Bitmap(Tile.fromColor(0xff0000));
		var shader = new SpriteShader();
		bkg.addShader(shader);
		bkg.width = 10000;
		bkg.height = 10000;

		layers = new Map();
		root = new Layers();
		scroller = new Layers();
		screen = new Layers();

		createLayer(BACKGROUND, WORLD);
		createLayer(GROUND, WORLD);
		createLayer(OBJECTS, WORLD);
		createLayer(ACTORS, WORLD);
		createLayer(OVERLAY, WORLD);
		createLayer(HUD, SCREEN);
		createLayer(POPUP, SCREEN);

		root.addChildAt(bkg, 0);
		root.addChildAt(scroller, 1);
		root.addChildAt(screen, 2);
	}

	function createLayer(type:RenderLayerType, space:RenderLayerSpace):RenderLayer
	{
		var layer = new RenderLayer(space);

		switch layer.space
		{
			case WORLD:
				scroller.add(layer.ob, scrollerCount++);
			case SCREEN:
				screen.add(layer.ob, screenCount++);
		}

		layers.set(type, layer);

		return layer;
	}

	public function render(layer:RenderLayerType, ob:h2d.Object)
	{
		layers.get(layer).ob.addChild(ob);
	}

	public function clear(layer:RenderLayerType)
	{
		layers.get(layer).ob.removeChildren();
	}

	public function clearAll()
	{
		layers.each(layer -> layer.ob.removeChildren());
	}

	public function sort(layer:RenderLayerType)
	{
		layers.get(layer).ob.ysort(0);
	}
}
