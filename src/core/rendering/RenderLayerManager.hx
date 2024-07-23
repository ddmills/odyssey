package core.rendering;

import core.rendering.RenderLayer.RenderLayerSpace;
import data.ColorKey;
import h2d.Bitmap;
import h2d.Layers;
import h2d.Tile;
import shaders.ScanlineShader;
import shaders.SpriteShader;

enum RenderLayerType
{
	BACKGROUND;
	GROUND;
	OBJECTS;
	ACTORS;
	FX;
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
		var bkg = new Bitmap(Tile.fromColor(ColorKey.C_CLEAR.toInt()));
		// var shader = new SpriteShader(0xff0000);
		// shader.isShrouded = 0;
		// shader.isLit = 0;
		// bkg.addShader(shader);
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
		createLayer(FX, WORLD);
		createLayer(OVERLAY, WORLD);
		createLayer(HUD, SCREEN);
		createLayer(POPUP, SCREEN);

		root.addChildAt(bkg, 0);
		root.addChildAt(scroller, 1);
		root.addChildAt(screen, 2);

		var scanlineShader = new h2d.filter.Shader<ScanlineShader>(new ScanlineShader(), "texture");

		root.filter = scanlineShader;
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
