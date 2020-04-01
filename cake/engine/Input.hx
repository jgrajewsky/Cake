package cake.engine;

import haxe.ds.Vector;

class Input {
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

	private static function keyUpdate(key:lime.ui.KeyCode, down:Bool):Void {
		switch key {
			case BACKSPACE:
				setKey(KeyCode.BACKSPACE, down);
			case DELETE:
				setKey(KeyCode.DELETE, down);
			case TAB:
				setKey(KeyCode.TAB, down);
			case CLEAR:
				setKey(KeyCode.CLEAR, down);
			case RETURN:
				setKey(KeyCode.RETURN, down);
			case PAUSE:
				setKey(KeyCode.PAUSE, down);
			case ESCAPE:
				setKey(KeyCode.ESCAPE, down);
			case SPACE:
				setKey(KeyCode.SPACE, down);
			case NUMPAD_0:
				setKey(KeyCode.NUMPAD_0, down);
			case NUMPAD_1:
				setKey(KeyCode.NUMPAD_1, down);
			case NUMPAD_2:
				setKey(KeyCode.NUMPAD_2, down);
			case NUMPAD_3:
				setKey(KeyCode.NUMPAD_3, down);
			case NUMPAD_4:
				setKey(KeyCode.NUMPAD_4, down);
			case NUMPAD_5:
				setKey(KeyCode.NUMPAD_5, down);
			case NUMPAD_6:
				setKey(KeyCode.NUMPAD_6, down);
			case NUMPAD_7:
				setKey(KeyCode.NUMPAD_7, down);
			case NUMPAD_8:
				setKey(KeyCode.NUMPAD_8, down);
			case NUMPAD_9:
				setKey(KeyCode.NUMPAD_9, down);
			case NUMPAD_00:
				setKey(KeyCode.NUMPAD_00, down);
			case NUMPAD_000:
				setKey(KeyCode.NUMPAD_000, down);
			case NUMPAD_PERIOD:
				setKey(KeyCode.NUMPAD_PERIOD, down);
			case NUMPAD_DIVIDE:
				setKey(KeyCode.NUMPAD_DIVIDE, down);
			case NUMPAD_MULTIPLY:
				setKey(KeyCode.NUMPAD_MULTIPLY, down);
			case NUMPAD_MINUS:
				setKey(KeyCode.NUMPAD_MINUS, down);
			case NUMPAD_PLUS:
				setKey(KeyCode.NUMPAD_PLUS, down);
			case NUMPAD_ENTER:
				setKey(KeyCode.NUMPAD_ENTER, down);
			case NUMPAD_EQUALS:
				setKey(KeyCode.NUMPAD_EQUALS, down);
			case UP:
				setKey(KeyCode.UP_ARROW, down);
			case DOWN:
				setKey(KeyCode.DOWN_ARROW, down);
			case RIGHT:
				setKey(KeyCode.RIGHT_ARROW, down);
			case LEFT:
				setKey(KeyCode.LEFT_ARROW, down);
			case INSERT:
				setKey(KeyCode.INSERT, down);
			case HOME:
				setKey(KeyCode.HOME, down);
			case END:
				setKey(KeyCode.END, down);
			case PAGE_UP:
				setKey(KeyCode.PAGE_UP, down);
			case PAGE_DOWN:
				setKey(KeyCode.PAGE_DOWN, down);
			case F1:
				setKey(KeyCode.F1, down);
			case F2:
				setKey(KeyCode.F2, down);
			case F3:
				setKey(KeyCode.F3, down);
			case F4:
				setKey(KeyCode.F4, down);
			case F5:
				setKey(KeyCode.F5, down);
			case F6:
				setKey(KeyCode.F6, down);
			case F7:
				setKey(KeyCode.F7, down);
			case F8:
				setKey(KeyCode.F8, down);
			case F9:
				setKey(KeyCode.F9, down);
			case F10:
				setKey(KeyCode.F10, down);
			case F11:
				setKey(KeyCode.F11, down);
			case F12:
				setKey(KeyCode.F12, down);
			case F13:
				setKey(KeyCode.F13, down);
			case F14:
				setKey(KeyCode.F14, down);
			case F15:
				setKey(KeyCode.F15, down);
			case F16:
				setKey(KeyCode.F16, down);
			case F17:
				setKey(KeyCode.F17, down);
			case F18:
				setKey(KeyCode.F18, down);
			case F19:
				setKey(KeyCode.F19, down);
			case F20:
				setKey(KeyCode.F20, down);
			case F21:
				setKey(KeyCode.F21, down);
			case F22:
				setKey(KeyCode.F22, down);
			case F23:
				setKey(KeyCode.F23, down);
			case F24:
				setKey(KeyCode.F24, down);
			case NUMBER_0:
				setKey(KeyCode.NUMBER_0, down);
			case NUMBER_1:
				setKey(KeyCode.NUMBER_1, down);
			case NUMBER_2:
				setKey(KeyCode.NUMBER_2, down);
			case NUMBER_3:
				setKey(KeyCode.NUMBER_3, down);
			case NUMBER_4:
				setKey(KeyCode.NUMBER_4, down);
			case NUMBER_5:
				setKey(KeyCode.NUMBER_5, down);
			case NUMBER_6:
				setKey(KeyCode.NUMBER_6, down);
			case NUMBER_7:
				setKey(KeyCode.NUMBER_7, down);
			case NUMBER_8:
				setKey(KeyCode.NUMBER_8, down);
			case NUMBER_9:
				setKey(KeyCode.NUMBER_9, down);
			case EXCLAMATION:
				setKey(KeyCode.EXCLAMATION, down);
			case QUOTE:
				setKey(KeyCode.QUOTE, down);
			case HASH:
				setKey(KeyCode.HASH, down);
			case DOLLAR:
				setKey(KeyCode.DOLLAR, down);
			case PERCENT:
				setKey(KeyCode.PERCENT, down);
			case AMPERSAND:
				setKey(KeyCode.AMPERSAND, down);
			case SINGLE_QUOTE:
				setKey(KeyCode.SINGLE_QUOTE, down);
			case LEFT_PARENTHESIS:
				setKey(KeyCode.LEFT_PARENTHESIS, down);
			case RIGHT_PARENTHESIS:
				setKey(KeyCode.RIGHT_PARENTHESIS, down);
			case ASTERISK:
				setKey(KeyCode.ASTERISK, down);
			case PLUS:
				setKey(KeyCode.PLUS, down);
			case COMMA:
				setKey(KeyCode.COMMA, down);
			case MINUS:
				setKey(KeyCode.MINUS, down);
			case PERIOD:
				setKey(KeyCode.PERIOD, down);
			case SLASH:
				setKey(KeyCode.SLASH, down);
			case COLON:
				setKey(KeyCode.COLON, down);
			case SEMICOLON:
				setKey(KeyCode.SEMICOLON, down);
			case LESS_THAN:
				setKey(KeyCode.LESS_THAN, down);
			case EQUALS:
				setKey(KeyCode.EQUALS, down);
			case GREATER_THAN:
				setKey(KeyCode.GREATER_THAN, down);
			case QUESTION:
				setKey(KeyCode.QUESTION, down);
			case AT:
				setKey(KeyCode.AT, down);
			case LEFT_BRACKET:
				setKey(KeyCode.LEFT_BRACKET, down);
			case BACKSLASH:
				setKey(KeyCode.BACKSLASH, down);
			case RIGHT_BRACKET:
				setKey(KeyCode.RIGHT_BRACKET, down);
			case CARET:
				setKey(KeyCode.CARET, down);
			case UNDERSCORE:
				setKey(KeyCode.UNDERSCORE, down);
			case GRAVE:
				setKey(KeyCode.GRAVE, down);
			case A:
				setKey(KeyCode.A, down);
			case B:
				setKey(KeyCode.B, down);
			case C:
				setKey(KeyCode.C, down);
			case D:
				setKey(KeyCode.D, down);
			case E:
				setKey(KeyCode.E, down);
			case F:
				setKey(KeyCode.F, down);
			case G:
				setKey(KeyCode.G, down);
			case H:
				setKey(KeyCode.H, down);
			case I:
				setKey(KeyCode.I, down);
			case J:
				setKey(KeyCode.J, down);
			case K:
				setKey(KeyCode.K, down);
			case L:
				setKey(KeyCode.L, down);
			case M:
				setKey(KeyCode.M, down);
			case N:
				setKey(KeyCode.N, down);
			case O:
				setKey(KeyCode.O, down);
			case P:
				setKey(KeyCode.P, down);
			case Q:
				setKey(KeyCode.Q, down);
			case R:
				setKey(KeyCode.R, down);
			case S:
				setKey(KeyCode.S, down);
			case T:
				setKey(KeyCode.T, down);
			case U:
				setKey(KeyCode.U, down);
			case V:
				setKey(KeyCode.V, down);
			case W:
				setKey(KeyCode.W, down);
			case X:
				setKey(KeyCode.X, down);
			case Y:
				setKey(KeyCode.Y, down);
			case Z:
				setKey(KeyCode.Z, down);
			// case LEFT_CURLY_BRACKET: setKey(KeyCode.LEFT_CURLY_BRACKET, down);
			// case PIPE: setKey(KeyCode.PIPE, down);
			// case RIGHT_CURLY_BRACKET: setKey(KeyCode.RIGHT_CURLY_BRACKET, down);
			// case TILDE: setKey(KeyCode.TILDE, down);
			case NUM_LOCK:
				setKey(KeyCode.NUM_LOCK, down);
			case CAPS_LOCK:
				setKey(KeyCode.CAPS_LOCK, down);
			case SCROLL_LOCK:
				setKey(KeyCode.SCROLL_LOCK, down);
			// SHIFT
			case LEFT_SHIFT:
				setKey(KeyCode.LEFT_SHIFT, down);
			case RIGHT_SHIFT:
				setKey(KeyCode.RIGHT_SHIFT, down);
			// CTRL
			case LEFT_CTRL:
				setKey(KeyCode.LEFT_CTRL, down);
			case RIGHT_CTRL:
				setKey(KeyCode.RIGHT_CTRL, down);
			// ALT
			case LEFT_ALT:
				setKey(KeyCode.LEFT_ALT, down);
			case RIGHT_ALT:
				setKey(KeyCode.RIGHT_ALT, down);
			// META
			case LEFT_META:
				setKey(KeyCode.LEFT_META, down);
			case RIGHT_META:
				setKey(KeyCode.RIGHT_META, down);
			case HELP:
				setKey(KeyCode.HELP, down);
			case PRINT_SCREEN:
				setKey(KeyCode.PRINT_SCREEN, down);
			case SYSTEM_REQUEST:
				setKey(KeyCode.SYS_REQ, down);
			case MENU:
				setKey(KeyCode.MENU, down);
			case EXECUTE:
				setKey(KeyCode.EXECUTE, down);
			case SELECT:
				setKey(KeyCode.SELECT, down);
			case STOP:
				setKey(KeyCode.STOP, down);
			case AGAIN:
				setKey(KeyCode.AGAIN, down);
			case UNDO:
				setKey(KeyCode.UNDO, down);
			case CUT:
				setKey(KeyCode.CUT, down);
			case COPY:
				setKey(KeyCode.COPY, down);
			case PASTE:
				setKey(KeyCode.PASTE, down);
			case FIND:
				setKey(KeyCode.FIND, down);
			case MUTE:
				setKey(KeyCode.MUTE, down);
			case VOLUME_UP:
				setKey(KeyCode.VOLUME_UP, down);
			case VOLUME_DOWN:
				setKey(KeyCode.VOLUME_DOWN, down);
			case AUDIO_NEXT:
				setKey(KeyCode.AUDIO_NEXT, down);
			case AUDIO_PREVIOUS:
				setKey(KeyCode.AUDIO_PREVIOUS, down);
			case AUDIO_STOP:
				setKey(KeyCode.AUDIO_STOP, down);
			case AUDIO_PLAY:
				setKey(KeyCode.AUDIO_PLAY, down);
			case AUDIO_MUTE:
				setKey(KeyCode.AUDIO_MUTE, down);
			case BRIGHTNESS_DOWN:
				setKey(KeyCode.BRIGHTNESS_DOWN, down);
			case BRIGHTNESS_UP:
				setKey(KeyCode.BRIGHTNESS_UP, down);
			// case MOUSE_0: setKey(KeyCode.MOUSE_0, down);
			// case MOUSE_1: setKey(KeyCode.MOUSE_1, down);
			// case MOUSE_2: setKey(KeyCode.MOUSE_2, down);
			default:
		}
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

	private static function update():Void {
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
