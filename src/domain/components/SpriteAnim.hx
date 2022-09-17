package domain.components;

import core.rendering.RenderLayerManager.RenderLayerType;
import data.TileKey;
import data.TileResources;
import h2d.Anim;
import h2d.Tile;
import shaders.SpriteShader;

class SpriteAnim extends Drawable
{
	@save public var tileKeys(default, set):Array<TileKey>;
	@save public var speed(default, set):Float;

	public var ob(default, null):Anim;
	public var tiles(get, never):Array<Tile>;

	public function new(tileKeys:Array<TileKey>, speed:Float = 15, primary = 0xffffff, secondary = 0x000000, layer = OBJECTS)
	{
		this.tileKeys = tileKeys == null ? [] : tileKeys;
		this.speed = speed;

		super(primary, secondary, layer);

		ob = new Anim(this.tiles, speed);
		ob.addShader(shader);
		ob.visible = false;
	}

	public function getAnimClone():Anim
	{
		var bm = new Anim(tiles, speed);
		var sh = new SpriteShader(primary, secondary);
		sh.isShrouded = isShrouded ? 1 : 0;
		if (background == null)
		{
			sh.clearBackground = 0;
		}
		else
		{
			sh.clearBackground = 1;
			sh.background = background.toHxdColor();
		}
		bm.addShader(sh);
		return bm;
	}

	function get_tiles():Array<Tile>
	{
		return tileKeys.map((key) -> TileResources.Get(key));
	}

	public function set_tileKeys(value:Array<TileKey>):Array<TileKey>
	{
		tileKeys = value;
		if (ob != null)
		{
			var old = ob;
			ob = new Anim(tiles, speed, old.parent);
			ob.x = old.x;
			ob.y = old.y;
			ob.addShader(shader);
			old.remove();
		}
		return value;
	}

	function set_speed(value:Float):Float
	{
		speed = value;
		if (ob != null)
		{
			ob.speed = value;
		}
		return value;
	}

	inline function getDrawable():h2d.Drawable
	{
		return ob;
	}
}
