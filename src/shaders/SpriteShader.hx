package shaders;

import core.Game;

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
			@global var dayProgress:Float;
			function fragment()
			{
				var uv = vec2(dayProgress, 0.0);
				var lightIntensityFactor = clamp(lightIntensity * .30, 0, 1);
				if (pixelColor.r == 0 && pixelColor.g == 0 && pixelColor.b == 0)
				{
					pixelColor.rgb = primary;

					if (isLit == 1)
					{
						pixelColor.rgb = mix(pixelColor.rgb, light, lightIntensityFactor);
					}
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
					if (isLit == 1)
					{
						pixelColor.rgb = mix(pixelColor.rgb, light, lightIntensityFactor);
					}
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

				if (pixelColor.a == 0)
				{
					if (clearBackground == 1)
					{
						pixelColor.a = 1;
						pixelColor.rgb = background;

						if (isShrouded == 1)
						{
							var color = pixelColor.rgb;
							var gray = vec3(dot(shroudColor, color));
							pixelColor.rgb = mix(mix(color, gray, .5) / shroudIntensity, shroudColor, .05);
						}
						else if (isLit == 1)
						{
							pixelColor.rgb = mix(pixelColor.rgb, light, lightIntensityFactor);
							pixelColor.a = 1;
						}
					}
					else
					{
						if (isLit == 1)
						{
							pixelColor.rgb = mix(outline, light, lightIntensityFactor);
							pixelColor.a = 1;
						}
					}
				}

				var lutY = 1 - pixelColor.g;
				var lutX = (floor(pixelColor.b * 32) / 32) + (pixelColor.r / 32);
				var uvv = vec2(lutX, lutY);
				var nightColor = night.get(uvv).rgb;
				pixelColor.rgb = mix(pixelColor.rgb, nightColor, 1 - dayProgress);
			}
		};

	public function new(primary:Int = 0x000000, secondary:Int = 0xffffff)
	{
		super();
		this.primary = primary.toHxdColor();
		this.secondary = secondary.toHxdColor();
		this.shroudIntensity = 2;
		this.shroudColor = 0x1E0524.toHxdColor();
		this.outline = Game.instance.CLEAR_COLOR.toHxdColor();
		this.background = Game.instance.CLEAR_COLOR.toHxdColor();
		this.clearBackground = 0;
		this.isShrouded = 0;
		this.isLit = 0;
		this.night = hxd.Res.images.lut.lut_night.toTexture();
	}
}
