package common.extensions;

import common.util.Easing;

class FloatEasingExtensions
{
	public static inline function zigzag(rate:Float, easing:EasingType):Float
	{
		return if (rate < 0.5) ease(rate * 2, easing) else 1 - ease((rate - 0.5) * 2, easing);
	}

	public static inline function yoyo(rate:Float, easing:EasingType):Float
	{
		return ease((if (rate < 0.5) rate else (1 - rate)) * 2, easing);
	}

	public static inline function ease(rate:Float, easing:EasingType):Float
	{
		return Easing.apply(rate, easing);
	}
}
