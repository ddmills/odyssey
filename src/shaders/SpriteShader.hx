package shaders;

import core.Game;

class SpriteShader extends hxsl.Shader
{
	static var SRC =
		{
			var pixelColor:Vec4;
			@param var primary:Vec3;
			@param var secondary:Vec3;
			@param var outline:Vec4;
			@param var background:Vec3;
			@param var clearBackground:Int;
			@param var isShrouded:Int;
			function fragment()
			{
				if (pixelColor.r == 0 && pixelColor.g == 0 && pixelColor.b == 0)
				{
					pixelColor.rgb = primary;
					if (isShrouded == 1)
					{
						var color = pixelColor.rgb;
						var lum = vec3(0.299, 0.587, 0.114);
						var gray = vec3(dot(lum, color));
						pixelColor.rgb = mix(color, gray, .25) * .5;
					}
				}
				else if (pixelColor.r == 1 && pixelColor.g == 1 && pixelColor.b == 1)
				{
					pixelColor.rgb = secondary;
					if (isShrouded == 1)
					{
						var color = pixelColor.rgb;
						var lum = vec3(0.299, 0.587, 0.114);
						var gray = vec3(dot(lum, color));
						pixelColor.rgb = mix(color, gray, .25) * .5;
					}
				}
				else if (pixelColor.r == 1 && pixelColor.g == 0 && pixelColor.b == 0)
				{
					pixelColor.rgba = outline;
				}

				if (pixelColor.a == 0 && clearBackground == 1)
				{
					pixelColor.a = 1;
					pixelColor.rgb = background;
				}
			}
		};

	public function new(primary:Int = 0x000000, secondary:Int = 0xffffff)
	{
		super();
		this.primary = primary.toHxdColor();
		this.secondary = secondary.toHxdColor();
		this.outline = Game.instance.CLEAR_COLOR.toHxdColor();
		this.background = Game.instance.CLEAR_COLOR.toHxdColor();
		this.clearBackground = 0;
		this.isShrouded = 0;
	}
}
