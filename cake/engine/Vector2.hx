package cake.engine;

private final class Vector2Impl {
	public var x:Float;
	public var y:Float;

	public inline function new(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}
}

@:forward abstract Vector2(Vector2Impl) from Vector2Impl to Vector2Impl {
	public inline function new(x:Float, y:Float) {
		this = new Vector2Impl(x, y);
	}

	// #region properties
	public var sqrMagnitude(get, never):Float;

	private inline function get_sqrMagnitude():Float {
		return this.x * this.x + this.y * this.y;
	}

	public var magnitude(get, set):Float;

	private inline function get_magnitude():Float {
		return Math.sqrt(get_sqrMagnitude());
	}

	private inline function set_magnitude(value:Float):Float {
		var current = get_magnitude();
		if (current == 0) {
			return 0;
		}
		multiplyFloatCompound(value / current);
		return value;
	}

	public var normalized(get, never):Vector2;

	private inline function get_normalized():Vector2 {
		return (this : Vector2) / get_magnitude();
	}

	// #endregion
	// #region functions

	public inline function set(x:Float, y:Float):Void {
		this.x = x;
		this.y = y;
	}

	public inline function clone():Vector2 {
		return new Vector2(this.x, this.y);
	}

	public inline function copy(from:Vector2):Void {
		this.x = from.x;
		this.y = from.y;
	}

	public inline function invert():Void {
		this.x *= -1.0;
		this.y *= -1.0;
	}

	public inline function normalize():Void {
		divideFloatCompound(get_magnitude());
	}

	public inline function toString():String {
		return '(${this.x}, ${this.y})';
	}

	// #endregion
	// #region static functions

	public static inline function dot(a:Vector2, b:Vector2):Float {
		return a.x * b.x + a.y * b.y;
	}

	public static inline function angle(from:Vector2, to:Vector2):Float {
		return Math.acos(dot(from, to) / (from.magnitude * to.magnitude));
	}

	public static inline function distance(from:Vector2, to:Vector2):Float {
		return Math.sqrt((to.x - from.x) * (to.x - from.x) + (to.y - from.y) * (to.y - from.y));
	}

	public static function swap(a:Vector2, b:Vector2):Void {
		var x = a.x;
		var y = a.y;
		a.copy(b);
		b.set(x, y);
	}

	public static inline function lerp(from:Vector2, to:Vector2, t:Float):Vector2 {
		return from + (to - from) * Math.fclamp(t, 0.0, 1.0);
	}

	public static function moveTowards(current:Vector2, target:Vector2, distance:Float):Vector2 {
		var delta = target - current;
		var sqDist = delta.sqrMagnitude;
		if (sqDist == 0 || (distance >= 0 && sqDist <= distance * distance)) {
			return target;
		}
		return current + delta / Math.sqrt(sqDist) * distance;
	}

	public static inline function min(a:Vector2, b:Vector2):Vector2 {
		return new Vector2(a.x < b.x ? a.x : b.x, a.y < b.y ? a.y : b.y);
	}

	public static inline function max(a:Vector2, b:Vector2):Vector2 {
		return new Vector2(a.x > b.x ? a.x : b.x, a.y > b.y ? a.y : b.y);
	}

	// #endregion
	// #region operators
	@:op(A == B) private inline function equal(other:Vector2):Bool {
		return this.x == other.x && this.y == other.y;
	}

	@:op(A == B) private inline function notEqual(other:Vector2):Bool {
		return this.x != other.x || this.y != other.y;
	}

	@:op(-A) private function invertOperator():Vector2 {
		var clone = clone();
		clone.invert();
		return clone;
	}

	@:op([]) private function arrayGet(index:Int):Float {
		switch index {
			case 0:
				return this.x;
			case 1:
				return this.y;
			default:
				throw "Invalid Vector2 index";
		}
	}

	@:op([]) private function arraySet(index:Int, value:Float):Float {
		switch index {
			case 0:
				return this.x = value;
			case 1:
				return this.y = value;
			default:
				throw "Invalid Vector2 index";
		}
	}

	@:op(A += B) private inline function addCompound(other:Vector2):Vector2 {
		this.x += other.x;
		this.y += other.y;
		return this;
	}

	@:op(A -= B) private inline function subtractCompound(other:Vector2):Vector2 {
		this.x -= other.x;
		this.y -= other.y;
		return this;
	}

	@:op(A *= B) private inline function multiplyCompound(other:Vector2):Vector2 {
		this.x *= other.x;
		this.y *= other.y;
		return this;
	}

	@:op(A /= B) private inline function divideCompound(other:Vector2):Vector2 {
		this.x /= other.x;
		this.y /= other.y;
		return this;
	}

	@:op(A %= B) private inline function modCompound(other:Vector2):Vector2 {
		this.x %= other.x;
		this.y %= other.y;
		return this;
	}

	@:op(A + B) private inline function add(other:Vector2):Vector2 {
		return clone().addCompound(other);
	}

	@:op(A - B) private inline function substract(other:Vector2):Vector2 {
		return clone().subtractCompound(other);
	}

	@:op(A * B) private inline function multiply(other:Vector2):Vector2 {
		return clone().multiplyCompound(other);
	}

	@:op(A / B) private inline function divide(other:Vector2):Vector2 {
		return clone().divideCompound(other);
	}

	@:op(A % B) private inline function mod(other:Vector2):Vector2 {
		return clone().modCompound(other);
	}

	@:op(A += B) private inline function addFloatCompound(other:Float):Vector2 {
		this.x += other;
		this.y += other;
		return this;
	}

	@:op(A -= B) private inline function subtractFloatCompound(other:Float):Vector2 {
		this.x -= other;
		this.y -= other;
		return this;
	}

	@:op(A *= B) private inline function multiplyFloatCompound(other:Float):Vector2 {
		this.x *= other;
		this.y *= other;
		return this;
	}

	@:op(A /= B) private inline function divideFloatCompound(other:Float):Vector2 {
		this.x /= other;
		this.y /= other;
		return this;
	}

	@:op(A %= B) private inline function modFloatCompound(other:Float):Vector2 {
		this.x %= other;
		this.y %= other;
		return this;
	}

	@:op(A + B) private inline function addFloat(other:Float):Vector2 {
		return clone().addFloatCompound(other);
	}

	@:op(A - B) private inline function substractFloat(other:Float):Vector2 {
		return clone().subtractFloatCompound(other);
	}

	@:op(A * B) private inline function multiplyFloat(other:Float):Vector2 {
		return clone().multiplyFloatCompound(other);
	}

	@:op(A / B) private inline function divideFloat(other:Float):Vector2 {
		return clone().divideFloatCompound(other);
	}

	@:op(A % B) private inline function modFloat(other:Float):Vector2 {
		return clone().modFloatCompound(other);
	}

	// #endregion
	// #region constants

	public static inline function zero():Vector2 {
		return new Vector2(0.0, 0.0);
	}

	public static inline function one():Vector2 {
		return new Vector2(1.0, 1.0);
	}

	public static inline function left():Vector2 {
		return new Vector2(-1.0, 0.0);
	}

	public static inline function right():Vector2 {
		return new Vector2(1.0, 0.0);
	}

	public static inline function down():Vector2 {
		return new Vector2(0.0, -1.0);
	}

	public static inline function up():Vector2 {
		return new Vector2(0.0, 1.0);
	}

	// #endregion
}
