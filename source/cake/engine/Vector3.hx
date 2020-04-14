package cake.engine;

private final class Vector3Impl {
	public var x(default, set):Float;
	public var y(default, set):Float;
	public var z(default, set):Float;
	private var hasChanged:Bool = true;

	public inline function new(x:Float, y:Float, z:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public inline function set_x(value:Float):Float {
		x = value;
		hasChanged = true;
		return x;
	}

	public inline function set_y(value:Float):Float {
		y = value;
		hasChanged = true;
		return y;
	}

	public inline function set_z(value:Float):Float {
		z = value;
		hasChanged = true;
		return z;
	}
}

@:forward abstract Vector3(Vector3Impl) from Vector3Impl {
	public inline function new(x:Float, y:Float, z:Float) {
		this = new Vector3Impl(x, y, z);
	}

	// #region properties
	public var sqrMagnitude(get, never):Float;

	private inline function get_sqrMagnitude():Float {
		return this.x * this.x + this.y * this.y + this.z * this.z;
	}

	public var magnitude(get, set):Float;

	private inline function get_magnitude():Float {
		return Math.sqrt(get_sqrMagnitude());
	}

	private function set_magnitude(value:Float):Float {
		var current = get_magnitude();
		if (current == 0) {
			return 0;
		}
		multiplyFloatCompound(value / current);
		return value;
	}

	public var normalized(get, never):Vector3;

	private inline function get_normalized():Vector3 {
		return (this : Vector3) / get_magnitude();
	}

	// #endregion
	// #region functions

	public inline function set(x:Float, y:Float, z:Float):Void {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public inline function clone():Vector3 {
		return new Vector3(this.x, this.y, this.z);
	}

	public inline function copy(from:Vector3):Void {
		this.x = from.x;
		this.y = from.y;
		this.z = from.z;
	}

	public inline function invert():Void {
		this.x *= -1.0;
		this.y *= -1.0;
		this.z *= -1.0;
	}

	public inline function normalize():Void {
		divideFloatCompound(get_magnitude());
	}

	public inline function toString():String {
		return '(${this.x}, ${this.y}, ${this.z})';
	}

	// #endregion
	// #region static functions

	public static inline function dot(a:Vector3, b:Vector3):Float {
		return a.x * b.x + a.y * b.y + a.z * b.z;
	}

	public static inline function cross(a:Vector3, b:Vector3):Vector3 {
		return new Vector3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
	}

	public static inline function angle(from:Vector3, to:Vector3):Float {
		return Math.acos(dot(from, to) / (from.magnitude * to.magnitude));
	}

	public static inline function distance(from:Vector3, to:Vector3):Float {
		return Math.sqrt((to.x - from.x) * (to.x - from.x) + (to.y - from.y) * (to.y - from.y) + (to.z - from.z) * (to.z - from.z));
	}

	public static function swap(a:Vector3, b:Vector3):Void {
		var x = a.x;
		var y = a.y;
		var z = a.z;
		a.copy(b);
		b.set(x, y, z);
	}

	public static inline function lerp(from:Vector3, to:Vector3, t:Float):Vector3 {
		return from + (to - from) * Math.fclamp(t, 0.0, 1.0);
	}

	public static function slerp(from:Vector3, to:Vector3, t:Float):Vector3 {
		var dot = dot(from, to);
		var theta = Math.acos(dot) * t;
		return from * Math.cos(theta) + (to - from * dot).normalized * Math.sin(theta);
	}

	public static function moveTowards(current:Vector3, target:Vector3, distance:Float):Vector3 {
		var delta = target - current;
		var sqDist = delta.sqrMagnitude;
		if (sqDist == 0 || (distance >= 0 && sqDist <= distance * distance)) {
			return target;
		}
		return current + delta / Math.sqrt(sqDist) * distance;
	}

	public static inline function min(a:Vector3, b:Vector3):Vector3 {
		return new Vector3(a.x < b.x ? a.x : b.x, a.y < b.y ? a.y : b.y, a.z < b.z ? a.z : b.z);
	}

	public static inline function max(a:Vector3, b:Vector3):Vector3 {
		return new Vector3(a.x > b.x ? a.x : b.x, a.y > b.y ? a.y : b.y, a.z > b.z ? a.z : b.z);
	}

	// #endregion
	// #region operators
	@:op(A == B) private inline function equal(other:Vector3):Bool {
		return this.x == other.x && this.y == other.y && this.z == other.z;
	}

	@:op(A == B) private inline function notEqual(other:Vector3):Bool {
		return this.x != other.x || this.y != other.y || this.z != other.z;
	}

	@:op(-A) private function invertOperator():Vector3 {
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
			case 2:
				return this.z;
			default:
				throw "Invalid Vector3 index";
		}
	}

	@:op([]) private function arraySet(index:Int, value:Float):Float {
		switch index {
			case 0:
				return this.x = value;
			case 1:
				return this.y = value;
			case 2:
				return this.z = value;
			default:
				throw "Invalid Vector3 index";
		}
	}

	@:op(A += B) private inline function addCompound(other:Vector3):Vector3 {
		this.x += other.x;
		this.y += other.y;
		this.z += other.z;
		return this;
	}

	@:op(A -= B) private inline function subtractCompound(other:Vector3):Vector3 {
		this.x -= other.x;
		this.y -= other.y;
		this.z -= other.z;
		return this;
	}

	@:op(A *= B) private inline function multiplyCompound(other:Vector3):Vector3 {
		this.x *= other.x;
		this.y *= other.y;
		this.z *= other.z;
		return this;
	}

	@:op(A /= B) private inline function divideCompound(other:Vector3):Vector3 {
		this.x /= other.x;
		this.y /= other.y;
		this.z /= other.z;
		return this;
	}

	@:op(A %= B) private inline function modCompound(other:Vector3):Vector3 {
		this.x %= other.x;
		this.y %= other.y;
		this.z %= other.z;
		return this;
	}

	@:op(A + B) private inline function add(other:Vector3):Vector3 {
		return clone().addCompound(other);
	}

	@:op(A - B) private inline function substract(other:Vector3):Vector3 {
		return clone().subtractCompound(other);
	}

	@:op(A * B) private inline function multiply(other:Vector3):Vector3 {
		return clone().multiplyCompound(other);
	}

	@:op(A / B) private inline function divide(other:Vector3):Vector3 {
		return clone().divideCompound(other);
	}

	@:op(A % B) private inline function mod(other:Vector3):Vector3 {
		return clone().modCompound(other);
	}

	@:op(A += B) private inline function addFloatCompound(other:Float):Vector3 {
		this.x += other;
		this.y += other;
		this.z += other;
		return this;
	}

	@:op(A -= B) private inline function subtractFloatCompound(other:Float):Vector3 {
		this.x -= other;
		this.y -= other;
		this.z -= other;
		return this;
	}

	@:op(A *= B) private inline function multiplyFloatCompound(other:Float):Vector3 {
		this.x *= other;
		this.y *= other;
		this.z *= other;
		return this;
	}

	@:op(A /= B) private inline function divideFloatCompound(other:Float):Vector3 {
		this.x /= other;
		this.y /= other;
		this.z /= other;
		return this;
	}

	@:op(A %= B) private inline function modFloatCompound(other:Float):Vector3 {
		this.x %= other;
		this.y %= other;
		this.z %= other;
		return this;
	}

	@:op(A + B) private inline function addFloat(other:Float):Vector3 {
		return clone().addFloatCompound(other);
	}

	@:op(A - B) private inline function substractFloat(other:Float):Vector3 {
		return clone().subtractFloatCompound(other);
	}

	@:op(A * B) private inline function multiplyFloat(other:Float):Vector3 {
		return clone().multiplyFloatCompound(other);
	}

	@:op(A / B) private inline function divideFloat(other:Float):Vector3 {
		return clone().divideFloatCompound(other);
	}

	@:op(A % B) private inline function modFloat(other:Float):Vector3 {
		return clone().modFloatCompound(other);
	}

	// #endregion
	// #region constants

	public static inline function zero():Vector3 {
		return new Vector3(0.0, 0.0, 0.0);
	}

	public static inline function one():Vector3 {
		return new Vector3(1.0, 1.0, 1.0);
	}

	public static inline function left():Vector3 {
		return new Vector3(-1.0, 0.0, 0.0);
	}

	public static inline function right():Vector3 {
		return new Vector3(1.0, 0.0, 0.0);
	}

	public static inline function down():Vector3 {
		return new Vector3(0.0, -1.0, 0.0);
	}

	public static inline function up():Vector3 {
		return new Vector3(0.0, 1.0, 0.0);
	}

	public static inline function back():Vector3 {
		return new Vector3(0.0, 0.0, -1.0);
	}

	public static inline function forward():Vector3 {
		return new Vector3(0.0, 0.0, 1.0);
	}

	// #endregion
}
