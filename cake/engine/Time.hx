package cake.engine;

class Time {
	public static var timeScale:Float = 1.0;
	public static var time:Float = 0.0;
	public static var deltaTime:Float;
	public static var unscaledTime:Float = 0.0;
	public static var unscaledDeltaTime:Float;
	public static var frameCount:Int = 0;

	private static inline function update(delta:Float) {
		delta /= 1000.0;
		deltaTime = delta * timeScale;
		unscaledDeltaTime = delta;
		time += deltaTime;
		unscaledTime += unscaledDeltaTime;
		++frameCount;
	}
}
