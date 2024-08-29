package domain.components;

import core.rendering.RenderLayerManager.RenderLayerType;
import data.AnimationKey;
import data.AnimationResources;
import data.ColorKey;
import h2d.Anim;
import h2d.Tile;
import shaders.SpriteShader;

class SpriteAnim extends Drawable
{
	@save public var animationKey(default, set):AnimationKey;
	@save public var speed(default, set):Float;
	@save public var loop(default, set):Bool;
	@save public var destroyOnComplete:Bool;

	public var ob(default, null):Anim;
	public var tiles(get, never):Array<Tile>;

	public function new(animationKey:AnimationKey, speed:Float = 15, primary = C_WHITE, secondary = C_BLACK, layer = OBJECTS, loop = true)
	{
		this.animationKey = animationKey;
		this.speed = speed;
		this.loop = loop;
		this.destroyOnComplete = false;

		super(primary, secondary, layer);

		ob = new Anim(tiles, speed);
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
		sh.setShrouded(isShrouded);
		if (background == null)
		{
			sh.clearBackground = 0;
		}
		else
		{
			sh.clearBackground = 1;
			sh.background = background.toHxdColor().toVector();
		}
		bm.addShader(sh);
		return bm;
	}

	function get_tiles():Array<Tile>
	{
		return AnimationResources.Get(animationKey);
	}

	public function set_animationKey(value:AnimationKey):AnimationKey
	{
		animationKey = value;
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
