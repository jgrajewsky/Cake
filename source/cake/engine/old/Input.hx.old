package cake.engine;

import haxe.ds.Vector;

@:allow(Main)
final class Input {
	/** The current mouse position in pixels. (Read Only) **/
	public static var mousePosition(default, null):Vector2 = Vector2.zero();

	/** The relative movement of the mouse compared to last frame in pixels. (Read Only) **/
	public static var mouseDelta(default, null):Vector2 = Vector2.zero();

	private static var keyStates:Vector<KeyState> = new Vector<KeyState>(169);

	/** Returns `true` if given `key` was pressed this frame. **/
	public static inline function keyPressed(key:KeyCode):Bool {
		return keyStates[key] == KeyState.PRESSED;
	}

	/** Returns `true` if given `key` is being held down. **/
	public static inline function keyHeld(key:KeyCode):Bool {
		return keyStates[key] != KeyState.NOT_HELD;
	}

	/** Returns `true` if given `key` was released this frame. **/
	public static inline function keyReleased(key:KeyCode):Bool {
		return keyStates[key] == KeyState.RELEASED;
	}

	private static function setKey(key:KeyCode, down:Bool):Void {
		if (down && keyStates[key] == KeyState.NOT_HELD) {
			keyStates[key] = KeyState.PRESSED;
		} else if (!down && keyStates[key] != KeyState.NOT_HELD) {
			keyStates[key] = KeyState.RELEASED;
		}
	}

	private static function start():Void {
		for (i in 0...keyStates.length) {
			keyStates[i] = 0;
		}
	}

	private static inline function update():Void {
		for (i in 0...keyStates.length) {
			switch keyStates[i] {
				case PRESSED:
					keyStates[i] = KeyState.HELD;
				case RELEASED:
					keyStates[i] = KeyState.NOT_HELD;
				default:
			}
		}
	}
}

@:enum private abstract KeyState(Int) from Int {
	var NOT_HELD;
	var PRESSED;
	var HELD;
	var RELEASED;
}
