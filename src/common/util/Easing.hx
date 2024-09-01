package common.util;

enum EasingType
{
	EASE_LINEAR;
	EASE_INSTANT;
	EASE_IN_QUAD;
	EASE_OUT_QUAD;
	EASE_IN_OUT_QUAD;
	EASE_IN_CUBIC;
	EASE_OUT_CUBIC;
	EASE_IN_OUT_CUBIC;
	EASE_IN_QUART;
	EASE_OUT_QUART;
	EASE_IN_OUT_QUART;
	EASE_IN_QUINT;
	EASE_OUT_QUINT;
	EASE_IN_OUT_QUINT;
	EASE_IN_SINE;
	EASE_OUT_SINE;
	EASE_IN_OUT_SINE;
	EASE_IN_EXPO;
	EASE_OUT_EXPO;
	EASE_IN_OUT_EXPO;
	EASE_IN_CIRC;
	EASE_OUT_CIRC;
	EASE_IN_OUT_CIRC;
	EASE_IN_BACK;
	EASE_OUT_BACK;
	EASE_IN_OUT_BACK;
	EASE_IN_ELASTIC;
	EASE_OUT_ELASTIC;
	EASE_IN_OUT_ELASTIC;
	EASE_OUT_BOUNCE;
	EASE_IN_BOUNCE;
	EASE_IN_OUT_BOUNCE;
}

typedef EasingFn = (n:Float) -> Float;

class Easing
{
	private static var c1 = 1.70158;
	private static var c2 = c1 * 1.525;
	private static var c3 = c1 + 1;
	private static var c4 = (2 * Math.PI) / 3;
	private static var c5 = (2 * Math.PI) / 4.5;

	static public inline function apply(x:Float, type:EasingType):Float
	{
		return getEasingFn(type)(x);
	}

	static public inline function applyZig(x:Float, type:EasingType):Float
	{
		var fn = getEasingFn(type);

		if (x < .5)
		{
			// [0, .5]
			// [0, 1]
			return fn(x * 2);
		}

		// [.5, 1]
		// [1, 0]
		return fn((1 - x) * 2);
	}

	static public function getEasingFn(type:EasingType)
	{
		switch type
		{
			case EASE_LINEAR:
				return Easing.easeLinear;
			case EASE_INSTANT:
				return Easing.easeInstant;
			case EASE_IN_QUAD:
				return Easing.easeInQuad;
			case EASE_OUT_QUAD:
				return Easing.easeOutQuad;
			case EASE_IN_OUT_QUAD:
				return Easing.easeInOutQuad;
			case EASE_IN_CUBIC:
				return Easing.easeInCubic;
			case EASE_OUT_CUBIC:
				return Easing.easeOutCubic;
			case EASE_IN_OUT_CUBIC:
				return Easing.easeInOutCubic;
			case EASE_IN_QUART:
				return Easing.easeInQuart;
			case EASE_OUT_QUART:
				return Easing.easeOutQuart;
			case EASE_IN_OUT_QUART:
				return Easing.easeInOutQuart;
			case EASE_IN_QUINT:
				return Easing.easeInQuint;
			case EASE_OUT_QUINT:
				return Easing.easeOutQuint;
			case EASE_IN_OUT_QUINT:
				return Easing.easeInOutQuint;
			case EASE_IN_SINE:
				return Easing.easeInSine;
			case EASE_OUT_SINE:
				return Easing.easeOutSine;
			case EASE_IN_OUT_SINE:
				return Easing.easeInOutSine;
			case EASE_IN_EXPO:
				return Easing.easeInExpo;
			case EASE_OUT_EXPO:
				return Easing.easeOutExpo;
			case EASE_IN_OUT_EXPO:
				return Easing.easeInOutExpo;
			case EASE_IN_CIRC:
				return Easing.easeInCirc;
			case EASE_OUT_CIRC:
				return Easing.easeOutCirc;
			case EASE_IN_OUT_CIRC:
				return Easing.easeInOutCirc;
			case EASE_IN_BACK:
				return Easing.easeInBack;
			case EASE_OUT_BACK:
				return Easing.easeOutBack;
			case EASE_IN_OUT_BACK:
				return Easing.easeInOutBack;
			case EASE_IN_ELASTIC:
				return Easing.easeInElastic;
			case EASE_OUT_ELASTIC:
				return Easing.easeOutElastic;
			case EASE_IN_OUT_ELASTIC:
				return Easing.easeInOutElastic;
			case EASE_OUT_BOUNCE:
				return Easing.easeOutBounce;
			case EASE_IN_BOUNCE:
				return Easing.easeInBounce;
			case EASE_IN_OUT_BOUNCE:
				return Easing.easeInOutBounce;
		}
	}

	static inline public function easeLinear(x:Float):Float
	{
		return x;
	}

	static inline public function easeInstant(x:Float):Float
	{
		return 1;
	}

	static public function easeInQuad(x:Float):Float
	{
		return x * x;
	}

	static public function easeOutQuad(x:Float):Float
	{
		return 1 - (1 - x) * (1 - x);
	}

	static public function easeInOutQuad(x:Float):Float
	{
		return x < 0.5 ? 2 * x * x : 1 - Math.pow(-2 * x + 2, 2) / 2;
	}

	static public function easeInCubic(x:Float):Float
	{
		return x * x * x;
	}

	static public function easeOutCubic(x:Float):Float
	{
		return 1 - Math.pow(1 - x, 3);
	}

	static public function easeInOutCubic(x:Float):Float
	{
		return x < 0.5 ? 4 * x * x * x : 1 - Math.pow(-2 * x + 2, 3) / 2;
	}

	static public function easeInQuart(x:Float):Float
	{
		return x * x * x * x;
	}

	static public function easeOutQuart(x:Float):Float
	{
		return 1 - Math.pow(1 - x, 4);
	}

	static public function easeInOutQuart(x:Float):Float
	{
		return x < 0.5 ? 8 * x * x * x * x : 1 - Math.pow(-2 * x + 2, 4) / 2;
	}

	static public function easeInQuint(x:Float):Float
	{
		return x * x * x * x * x;
	}

	static public function easeOutQuint(x:Float):Float
	{
		return 1 - Math.pow(1 - x, 5);
	}

	static public function easeInOutQuint(x:Float):Float
	{
		return x < 0.5 ? 16 * x * x * x * x * x : 1 - Math.pow(-2 * x + 2, 5) / 2;
	}

	static public function easeInSine(x:Float):Float
	{
		return 1 - Math.cos((x * Math.PI) / 2);
	}

	static public function easeOutSine(x:Float):Float
	{
		return Math.sin((x * Math.PI) / 2);
	}

	static public function easeInOutSine(x:Float):Float
	{
		return -(Math.cos(Math.PI * x) - 1) / 2;
	}

	static public function easeInExpo(x:Float):Float
	{
		return x == 0 ? 0 : Math.pow(2, 10 * x - 10);
	}

	static public function easeOutExpo(x:Float):Float
	{
		return x == 1 ? 1 : 1 - Math.pow(2, -10 * x);
	}

	static public function easeInOutExpo(x:Float):Float
	{
		return x == 0 ? 0 : x == 1 ? 1 : x < 0.5 ? Math.pow(2, 20 * x - 10) / 2 : (2 - Math.pow(2, -20 * x + 10)) / 2;
	}

	static public function easeInCirc(x:Float):Float
	{
		return 1 - Math.sqrt(1 - Math.pow(x, 2));
	}

	static public function easeOutCirc(x:Float):Float
	{
		return Math.sqrt(1 - Math.pow(x - 1, 2));
	}

	static public function easeInOutCirc(x:Float):Float
	{
		return x < 0.5 ? (1 - Math.sqrt(1 - Math.pow(2 * x, 2))) / 2 : (Math.sqrt(1 - Math.pow(-2 * x + 2, 2)) + 1) / 2;
	}

	static public function easeInBack(x:Float):Float
	{
		return c3 * x * x * x - c1 * x * x;
	}

	static public function easeOutBack(x:Float):Float
	{
		return 1 + c3 * Math.pow(x - 1, 3) + c1 * Math.pow(x - 1, 2);
	}

	static public function easeInOutBack(x:Float):Float
	{
		return x < 0.5 ? (Math.pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2 : (Math.pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2;
	}

	static public function easeInElastic(x:Float):Float
	{
		return x == 0 ? 0 : x == 1 ? 1 : -Math.pow(2, 10 * x - 10) * Math.sin((x * 10 - 10.75) * c4);
	}

	static public function easeOutElastic(x:Float):Float
	{
		return x == 0 ? 0 : x == 1 ? 1 : Math.pow(2, -10 * x) * Math.sin((x * 10 - 0.75) * c4) + 1;
	}

	static public function easeInOutElastic(x:Float):Float
	{
		return x == 0 ? 0 : x == 1 ? 1 : x < 0.5 ?
			-(Math.pow(2, 20 * x - 10) * Math.sin((20 * x - 11.125) * c5)) / 2 : (Math.pow(2, -20 * x + 10) * Math.sin((20 * x - 11.125) * c5)) / 2 + 1;
	}

	static public function easeOutBounce(x:Float):Float
	{
		var n1 = 7.5625;
		var d1 = 2.75;
		if (x < 1 / d1)
		{
			return n1 * x * x;
		}
		else if (x < 2 / d1)
		{
			return n1 * (x -= 1.5 / d1) * x + 0.75;
		}
		else if (x < 2.5 / d1)
		{
			return n1 * (x -= 2.25 / d1) * x + 0.9375;
		}
		else
		{
			return n1 * (x -= 2.625 / d1) * x + 0.984375;
		}
	}

	static public function easeInBounce(x:Float):Float
	{
		return 1 - easeOutBounce(1 - x);
	}

	static public function easeInOutBounce(x:Float):Float
	{
		return x < 0.5 ? (1 - easeOutBounce(1 - 2 * x)) / 2 : (1 + easeOutBounce(2 * x - 1)) / 2;
	}
}
