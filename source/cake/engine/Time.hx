package cake.engine;

@:allow(Main)
final class Time {
	/** The scale at which time passes. Default is `1.0`**/
	public static var timeScale:Float = 1.0;

	/** The time in seconds since the start of the game. (Read only) **/
	public static var time(default, null):Float = 0.0;

	/** The time in seconds between the last and the current frame. (Read only) **/
	public static var deltaTime(default, null):Float;

	/** The `timeScale`-independent time in seconds since the start of the game. (Read only) **/
	public static var unscaledTime(default, null):Float = 0.0;

	/** The `timeScale`-independent time in seconds between the last and the current frame. (Read only) **/
	public static var unscaledDeltaTime(default, null):Float;

	/** The total number of frames that have passed. (Read Only) **/
	public static var frameCount(default, null):Int = 0;

	private static inline function update(delta:Float):Void {
		deltaTime = delta * timeScale;
		unscaledDeltaTime = delta;
		time += deltaTime;
		unscaledTime += unscaledDeltaTime;
		++frameCount;
	}
}
