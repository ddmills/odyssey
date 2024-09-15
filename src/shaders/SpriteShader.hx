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
			@param var isLit:Int;
			@param var ignoreLighting:Int;
			@param var seed:Int;
			@param var lightColor:Vec3;
			@param var lightIntensity:Float;
			@param var lutSize:Int;
			@param var lut:Sampler2D;
			@global var time:Float;
			@global var ambient:Float;
			@global var dayProgress:Float;
			@global var clearColor:Vec3;
			function fragment()
			{
				var color = pixelColor.rgb;
				var isBackground = pixelColor.a == 0;
				var isPrimary = !isBackground && pixelColor.r == 0 && pixelColor.g == 0 && pixelColor.b == 0;
				var isSecondary = !isBackground && pixelColor.r == 1 && pixelColor.g == 1 && pixelColor.b == 1;
				var isOutline = !isBackground && pixelColor.r == 1 && pixelColor.g == 0 && pixelColor.b == 0;

				var t1 = ((sin((time) * 2) + 1) / 2) * .85;
				var t2 = ((sin((time + seed) * 24) + 1) / 2) * .15;
				var t = (t1 + t2);

				var scaled = .5 + (t * .5);
				var nightIntensity = (1 - ambient) * .75;
				var intensity = (scaled * lightIntensity);

				if (sin((time + seed) * .8) > -0.025 && sin((time + seed) * .8) < 0.025)
				{
					intensity = intensity * .75;
				}

				var c = color;
				var applyLighting = ignoreLighting == 0;

				if (isPrimary)
				{
					color = primary;
				}
				else if (isSecondary)
				{
					color = secondary;
				}
				else if (isOutline)
				{
					color = outline;
					applyLighting = false;
				}
				else if (isBackground)
				{
					if (clearBackground == 1)
					{
						color = background;
						pixelColor.a = 1;
						applyLighting = false;
					}
				}

				if (color.r == 1.0 && color.g == 1.0 && color.b == 0.0)
				{
					color = clearColor;
					applyLighting = false;
				}

				if (applyLighting)
				{
					if (isLit == 1)
					{
						var i = (intensity * nightIntensity) * .76;
						color = mix(color, lightColor, i);
						nightIntensity = nightIntensity * (1 - intensity);
					}

					if (isShrouded == 1)
					{
						color = mix(color, shroudColor, .925);
					}

					var lutY = 1 - color.g;
					var lutX = (floor(color.b * 32) / 32) + (color.r / 32);
					var uvv = vec2(lutX, lutY);
					var nightColor = lut.get(uvv).rgb;
					color = mix(color, nightColor, nightIntensity);
				}

				pixelColor.rgb = color;
			}
		};

	public function new(primary:Int = 0x000000, secondary:Int = 0xffffff)
	{
		super();
		this.primary = primary.toHxdColor().toVector();
		this.secondary = secondary.toHxdColor().toVector();
		this.shroudColor = ColorKey.C_SHROUD.toHxdColor().toVector();
		this.outline = ColorKey.C_CLEAR.toHxdColor().toVector();
		this.background = ColorKey.C_CLEAR.toHxdColor().toVector();
		this.clearBackground = 0;
		this.isShrouded = 0;
		this.isLit = 0;
		this.ignoreLighting = 0;
		this.lightColor = ColorKey.C_BRIGHT_WHITE.toHxdColor().toVector();
		this.lightIntensity = 1;
		this.seed = Game.instance.world.rand.integer(0, 10000);
		this.lut = hxd.Res.images.lut.lut_night.toTexture();
	}

	public function setShrouded(value:Bool)
	{
		isShrouded = value ? 1 : 0;
	}
}
