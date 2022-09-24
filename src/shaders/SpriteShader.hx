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
					baseColor = background;
				}

				if (isShrouded == 1)
				{
					var gray = vec3(dot(shroudColor, baseColor));
					baseColor = mix(mix(baseColor, gray, .5) / shroudIntensity, shroudColor, .05);
				}

				if (enableLut == 1)
				{
					var lutY = 1 - baseColor.g;
					var lutX = (floor(baseColor.b * 32) / 32) + (baseColor.r / 32);
					var uvv = vec2(lutX, lutY);
					var nightColor = night.get(uvv).rgb;
					baseColor = mix(baseColor, nightColor, 1 - dayProgress);
				}

				pixelColor.rgb = baseColor;

				if (isBackground && clearBackground == 1)
				{
					pixelColor.a = 1;
				}

				if (isLit == 1)
				{
					var lightIntensityFactor = clamp(lightIntensity / 5, 0, .75);

					pixelColor.rgb = mix(pixelColor.rgb, light, lightIntensityFactor);

					if (isBackground)
					{
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
		this.shroudIntensity = 2;
		this.shroudColor = 0x1E0524.toHxdColor();
		this.outline = Game.instance.CLEAR_COLOR.toHxdColor();
		this.background = Game.instance.CLEAR_COLOR.toHxdColor();
		this.clearBackground = 0;
		this.isShrouded = 0;
		this.isLit = 0;
		this.enableLut = 1;
		this.night = hxd.Res.images.lut.lut_night.toTexture();
	}
}
