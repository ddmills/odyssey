package shaders;

import h3d.shader.ScreenShader;

class ScanlineShader extends ScreenShader
{
	static var SRC =
		{
			@param var texture:Sampler2D;
			@highp var idx:Float;
			@global var screenH:Float;
			@global var time:Float;
			function fragment()
			{
				var pi = 3.14159265;
				var blurSize = 0.15;
				var subtleLevel = .8;
				var scanlineSize = 3;
				var boost = 1.125;
				var invH = 1. / screenH;

				var blur = vec4(0., 0., 0., 0.);
				var uv = calculatedUV;
				blur += texture.get(uv + vec2(-blurSize, -blurSize) * invH);
				blur += texture.get(uv + vec2(-blurSize, blurSize) * invH);
				blur += texture.get(uv + vec2(blurSize, -blurSize) * invH);
				blur += texture.get(uv + vec2(blurSize, blurSize) * invH);

				blur += texture.get(uv + vec2(-blurSize, 0) * invH);
				blur += texture.get(uv + vec2(blurSize, 0) * invH);
				blur += texture.get(uv + vec2(-blurSize, -blurSize) * invH);
				blur += texture.get(uv + vec2(0, -blurSize) * invH);
				blur += texture.get(uv + vec2(0, blurSize) * invH);
				blur *= 0.125;

				var vPos = calculatedUV.y * screenH;
				var r = fract(sin(dot(calculatedUV * time, vec2(12.9898, 78.233))) * 43758.5453);
				var lineIntensity = (subtleLevel) + abs(cos(pi / scanlineSize * vPos));

				var amt = clamp(lineIntensity, 0.0, 1.125);

				pixelColor = blur * amt * boost;
			}
		};
}
