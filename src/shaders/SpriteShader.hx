package shaders;

import core.Game;
import data.ColorKey;

class SpriteShader extends hxsl.Shader
{
	static var SRC =
		{
			var pixelColor:Vec4;
			@param var primary:Vec3;
			@param var secondary:Vec3;
			@param var outline:Vec3;
			@param var background:Vec3;
			@param var clearBackground:Int;
			@param var isShrouded:Int;
			@param var shroudColor:Vec3;
			function fragment()
			{
				var isBackground = pixelColor.a == 0;
				var isPrimary = !isBackground && pixelColor.r == 0 && pixelColor.g == 0 && pixelColor.b == 0;
				var isSecondary = !isBackground && pixelColor.r == 1 && pixelColor.g == 1 && pixelColor.b == 1;
				var isOutline = !isBackground && pixelColor.r == 1 && pixelColor.g == 0 && pixelColor.b == 0;

				var baseColor = pixelColor.rgb;

				if (isPrimary)
				{
					baseColor = primary;
				}
				else if (isSecondary)
				{
					baseColor = secondary;
				}
				else if (isOutline)
				{
					baseColor = outline;
				}
				else if (isBackground)
				{
					if (clearBackground == 1)
					{
						baseColor = background;
						pixelColor.a = 1;
					}
				}

				if (isPrimary && isShrouded == 1)
				{
					baseColor = mix(baseColor, shroudColor, .925);
				}

				if (isSecondary && isShrouded == 1)
				{
					baseColor = mix(baseColor, shroudColor, .925);
				}

				pixelColor.rgb = baseColor;
			}
		};

	public function new(primary:Int = 0x000000, secondary:Int = 0xffffff)
	{
		super();
		this.primary = primary.toHxdColor().toVector();
		this.secondary = secondary.toHxdColor().toVector();
		this.shroudColor = ColorKey.C_SHROUD.toHxdColor().toVector();
		this.outline = Game.instance.CLEAR_COLOR.toHxdColor().toVector();
		this.background = Game.instance.CLEAR_COLOR.toHxdColor().toVector();
		this.clearBackground = 0;
		this.isShrouded = 0;
	}

	public function setShrouded(value:Bool)
	{
		isShrouded = value ? 1 : 0;
	}
}
