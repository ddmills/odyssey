package shaders;

import core.Game;

class SpriteShader extends hxsl.Shader
{
	static var SRC =
		{
			var pixelColor:Vec4;
			@param var primary:Vec3;
			@param var secondary:Vec3;
			@param var outline:Vec3;
			@param var background:Vec3;
			@param var isLit:Int;
			@param var light:Vec3;
			@param var lightIntensity:Float;
			@param var clearBackground:Int;
			@param var isShrouded:Int;
			@param var shroudColor:Vec3;
			@param var shroudIntensity:Float;
			function fragment()
			{
				if (pixelColor.r == 0 && pixelColor.g == 0 && pixelColor.b == 0)
				{
					pixelColor.rgb = primary;
					if (isShrouded == 1)
					{
						var color = pixelColor.rgb;
						var gray = vec3(dot(shroudColor, color));
						pixelColor.rgb = mix(mix(color, gray, .5) / shroudIntensity, shroudColor, .05);
					}
				}
				else if (pixelColor.r == 1 && pixelColor.g == 1 && pixelColor.b == 1)
				{
					pixelColor.rgb = secondary;
					if (isShrouded == 1)
					{
						var color = pixelColor.rgb;
						var gray = vec3(dot(shroudColor, color));
						pixelColor.rgb = mix(mix(color, gray, .5) / shroudIntensity, shroudColor, .05);
					}
				}
				else if (pixelColor.r == 1 && pixelColor.g == 0 && pixelColor.b == 0)
				{
					pixelColor.rgb = outline;
				}

				if (pixelColor.a == 0 && clearBackground == 1)
				{
					pixelColor.a = 1;
					pixelColor.rgb = background;
					if (isShrouded == 1)
					{
						var color = pixelColor.rgb;
						var gray = vec3(dot(shroudColor, color));
						pixelColor.rgb = mix(mix(color, gray, .5) / shroudIntensity, shroudColor, .05);
						pixelColor.a = 0;
					}
					else if (isLit == 1)
					{
						pixelColor.rgb = mix(background, light, lightIntensity / 3);
						pixelColor.a = 1;
					}
				}
			}
		};

	public function new(primary:Int = 0x000000, secondary:Int = 0xffffff)
	{
		super();
		this.primary = primary.toHxdColor();
		this.secondary = secondary.toHxdColor();
		this.shroudIntensity = 1.5;
		this.shroudColor = 0x2F0838.toHxdColor();
		this.outline = Game.instance.CLEAR_COLOR.toHxdColor();
		this.background = Game.instance.CLEAR_COLOR.toHxdColor();
		this.clearBackground = 0;
		this.isShrouded = 0;
		this.isLit = 0;
	}
}
