package cake.engine;

@:forwardStatics
abstract Math(std.Math) {
	public static inline var DEG_2_RAD = 0.01745329252;
	public static inline var RAD_2_DEG = 57.29577951308;

	public static inline function fmin(a:Float, b:Float):Float {
		return a < b ? a : b;
	}

	public static inline function fmax(a:Float, b:Float):Float {
		return a > b ? a : b;
	}

	public static inline function min(a:Int, b:Int):Int {
		return a < b ? a : b;
	}

	public static inline function max(a:Int, b:Int):Int {
		return a > b ? a : b;
	}

	public static inline function fclamp(value:Float, min:Float, max:Float):Float {
		return Math.fmin(Math.fmax(value, min), max);
	}

	public static inline function clamp(value:Int, min:Int, max:Int):Int {
		return Math.min(Math.max(value, min), max);
	}

	public static inline function lerp(from:Float, to:Float, t:Float):Float {
		return from + (to - from) * fclamp(t, 0.0, 1.0);
	}

	public static inline function pingPong(value:Float, from:Float, to:Float):Float {
		var range = to - from;
		return from + Math.abs(((value + range) % (range * 2)) - range);
	}

	public static function moveTowards(current:Float, target:Float, distance:Float):Float {
		var delta = target - current;
		var dist = Math.abs(delta);
		if (dist == 0 || (distance >= 0 && dist <= distance)) {
			return target;
		}
		return current + delta / dist * distance;
	}
}
