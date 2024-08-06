package shaders;

import core.Game;
import data.ColorKey;

class SpriteShader extends hxsl.Shader
{
	static function tint() {}

	static var SRC =
		{
			var pixelColor:Vec4;
			@param var lutSize:Int;
			@param var night:Sampler2D;
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
			@param var enableLut:Int;
			@global var dayProgress:Float;
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
					pixelColor.a = .75;
				}
				else if (isBackground)
				{
					if (clearBackground == 1)
					{
						// baseColor = mix(background, vec3(0, 0, 0), .25);
						baseColor = background;
						pixelColor.a = 1;
					}
				}

				if (isPrimary && isShrouded == 1)
				{
					// var gray = vec3(dot(shroudColor, baseColor));
					// baseColor = mix(mix(baseColor, gray, .5) / shroudIntensity, shroudColor, .2);
					// baseColor = shroudColor;
					baseColor = mix(shroudColor, baseColor, .1);
				}
				if (isSecondary && isShrouded == 1)
				{
					// var gray = vec3(dot(shroudColor, baseColor));
					// baseColor = mix(mix(baseColor, gray, .5) / shroudIntensity, shroudColor, .2);
					baseColor = mix(shroudColor, baseColor, .1);
					// baseColor = shroudColor;
				}

				// if (enableLut == 1)
				// {
				// 	var lutY = 1 - baseColor.g;
				// 	var lutX = (floor(baseColor.b * 32) / 32) + (baseColor.r / 32);
				// 	var uvv = vec2(lutX, lutY);
				// 	var nightColor = night.get(uvv).rgb;
				// 	baseColor = mix(baseColor, nightColor, 1 - dayProgress);
				// }

				pixelColor.rgb = baseColor;

				// if (isBackground && clearBackground == 1)
				// {
				// 	pixelColor.a = 1;
				// }

				// if (isLit == 1 && isShrouded == 0)
				// {
				// 	var lightIntensityFactor = clamp(lightIntensity / 5, 0, .75);

				// 	pixelColor.rgb = mix(pixelColor.rgb, light, lightIntensityFactor);

				// 	if (isBackground)
				// 	{
				// 		pixelColor.a = 1;
				// 	}
				// }
			}
		};

	public function new(primary:Int = 0x000000, secondary:Int = 0xffffff)
	{
		super();
		this.primary = primary.toHxdColor().toVector();
		this.secondary = secondary.toHxdColor().toVector();
		this.shroudIntensity = 1.75;
		this.shroudColor = ColorKey.C_SHROUD.toHxdColor().toVector();
		// this.shroudColor = Game.instance.CLEAR_COLOR.toHxdColor().toVector();
		this.outline = Game.instance.CLEAR_COLOR.toHxdColor().toVector();
		this.background = Game.instance.CLEAR_COLOR.toHxdColor().toVector();
		this.clearBackground = 0;
		this.isShrouded = 0;
		this.isLit = 0;
		this.enableLut = 1;
		this.night = hxd.Res.images.lut.lut_night.toTexture();
	}
}
