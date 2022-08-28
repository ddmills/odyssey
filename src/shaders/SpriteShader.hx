package shaders;

import core.Game;

class SpriteShader extends hxsl.Shader
{
	static var SRC =
		{
			var pixelColor:Vec4;
			@param var primary:Vec3;
			@param var secondary:Vec3;
			@param var clearColor:Vec3;
			function fragment()
			{
				if (pixelColor.r == 0 && pixelColor.g == 0 && pixelColor.b == 0)
				{
					pixelColor.rgb = primary;
				}
				else if (pixelColor.r == 1 && pixelColor.g == 1 && pixelColor.b == 1)
				{
					pixelColor.rgb = secondary;
				}
				if (pixelColor.a == 0)
				{
					pixelColor.a = 1;
					pixelColor.rgb = clearColor;
				}
			}
		};

	public function new(primary:Int, secondary:Int)
	{
		super();
		this.primary = primary.toHxdColor();
		this.secondary = secondary.toHxdColor();
		this.clearColor = Game.instance.CLEAR_COLOR.toHxdColor();
	}
}
