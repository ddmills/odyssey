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
	@save public var loop(default, set):Bool;
	@save public var destroyOnComplete:Bool;

	public var ob(default, null):Anim;
	public var tiles(get, never):Array<Tile>;

	public function new(tileKeys:Array<TileKey>, speed:Float = 15, primary = 0xffffff, secondary = 0x000000, layer = OBJECTS, loop = true)
	{
		this.tileKeys = tileKeys == null ? [] : tileKeys;
		this.speed = speed;
		this.loop = loop;
		this.destroyOnComplete = false;

		super(primary, secondary, layer);

		ob = new Anim(this.tiles, speed);
		ob.loop = loop;
		ob.addShader(shader);
		ob.visible = false;
		ob.onAnimEnd = onAnimEnd;
	}

	private function onAnimEnd()
	{
		if (!loop)
		{
			ob.visible = false;
		}
		if (destroyOnComplete)
		{
			entity.add(new IsDestroyed());
		}
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
			ob.loop = loop;
			ob.x = old.x;
			ob.y = old.y;
			ob.visible = isVisible;
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

	function set_loop(value:Bool):Bool
	{
		loop = value;
		if (ob != null)
		{
			ob.loop = value;
		}
		return value;
	}
}
