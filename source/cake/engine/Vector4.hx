package cake.engine;

private final class Vector4Impl {
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;

	public function new(x:Float, y:Float, z:Float, w:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
}

@:forward abstract Vector4(Vector4Impl) from Vector4Impl {
	public inline function new(x:Float, y:Float, z:Float, w:Float) {
		this = new Vector4Impl(x, y, z, w);
	}

	// #region properties
	public var sqrMagnitude(get, never):Float;

	private inline function get_sqrMagnitude():Float {
		return this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w;
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

	public var normalized(get, never):Vector4;

	private inline function get_normalized():Vector4 {
		return (this : Vector4) / get_magnitude();
	}

	// #endregion
	// #region functions

	public function set(x:Float, y:Float, z:Float, w:Float):Void {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public inline function clone():Vector4 {
		return new Vector4(this.x, this.y, this.z, this.w);
	}

	public function copy(from:Vector4):Void {
		this.x = from.x;
		this.y = from.y;
		this.z = from.z;
		this.w = from.w;
	}

	public function invert():Void {
		this.x *= -1.0;
		this.y *= -1.0;
		this.z *= -1.0;
		this.w *= -1.0;
	}

	public inline function normalize():Void {
		divideFloatCompound(get_magnitude());
	}

	public inline function toString():String {
		return '(${this.x}, ${this.y}, ${this.z}, ${this.w})';
	}

	// #endregion
	// #region static functions

	public static inline function dot(a:Vector4, b:Vector4):Float {
		return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
	}

	public static function distance(from:Vector4, to:Vector4):Float {
		return Math.sqrt((to.x - from.x) * (to.x - from.x) + (to.y - from.y) * (to.y - from.y) + (to.z - from.z) * (to.z - from.z)
			+ (to.w - from.w) * (to.w - from.w));
	}

	public static function swap(a:Vector4, b:Vector4):Void {
		var x = a.x;
		var y = a.y;
		var z = a.z;
		var w = a.w;
		a.copy(b);
		b.set(x, y, z, w);
	}

	public static inline function lerp(from:Vector4, to:Vector4, t:Float):Vector4 {
		return from + (to - from) * Math.fclamp(t, 0.0, 1.0);
	}

	public static function moveTowards(current:Vector4, target:Vector4, distance:Float):Vector4 {
		var delta = target - current;
		var sqDist = delta.sqrMagnitude;
		if (sqDist == 0 || (distance >= 0 && sqDist <= distance * distance)) {
			return target;
		}
		return current + delta / Math.sqrt(sqDist) * distance;
	}

	public static function min(a:Vector4, b:Vector4):Vector4 {
		return new Vector4(a.x < b.x ? a.x : b.x, a.y < b.y ? a.y : b.y, a.z < b.z ? a.z : b.z, a.w < b.w ? a.w : b.w);
	}

	public static function max(a:Vector4, b:Vector4):Vector4 {
		return new Vector4(a.x > b.x ? a.x : b.x, a.y > b.y ? a.y : b.y, a.z > b.z ? a.z : b.z, a.w > b.w ? a.w : b.w);
	}

	// #endregion
	// #region operators
	@:op(A == B) private inline function equal(other:Vector4):Bool {
		return this.x == other.x && this.y == other.y && this.z == other.z && this.w == other.w;
	}

	@:op(A == B) private inline function notEqual(other:Vector4):Bool {
		return this.x != other.x || this.y != other.y || this.z != other.z || this.w != other.w;
	}

	@:op(-A) private function invertOperator():Vector4 {
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
			case 3:
				return this.w;
			default:
				throw "Invalid Vector4 index";
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
			case 3:
				return this.w = value;
			default:
				throw "Invalid Vector4 index";
		}
	}

	@:op(A += B) private function addCompound(other:Vector4):Vector4 {
		this.x += other.x;
		this.y += other.y;
		this.z += other.z;
		this.w += other.w;
		return this;
	}

	@:op(A -= B) private function subtractCompound(other:Vector4):Vector4 {
		this.x -= other.x;
		this.y -= other.y;
		this.z -= other.z;
		this.w -= other.w;
		return this;
	}

	@:op(A *= B) private function multiplyCompound(other:Vector4):Vector4 {
		this.x *= other.x;
		this.y *= other.y;
		this.z *= other.z;
		this.w *= other.w;
		return this;
	}

	@:op(A /= B) private function divideCompound(other:Vector4):Vector4 {
		this.x /= other.x;
		this.y /= other.y;
		this.z /= other.z;
		this.w /= other.w;
		return this;
	}

	@:op(A %= B) private function modCompound(other:Vector4):Vector4 {
		this.x %= other.x;
		this.y %= other.y;
		this.z %= other.z;
		this.w %= other.w;
		return this;
	}

	@:op(A + B) private inline function add(other:Vector4):Vector4 {
		return clone().addCompound(other);
	}

	@:op(A - B) private inline function substract(other:Vector4):Vector4 {
		return clone().subtractCompound(other);
	}

	@:op(A * B) private inline function multiply(other:Vector4):Vector4 {
		return clone().multiplyCompound(other);
	}

	@:op(A / B) private inline function divide(other:Vector4):Vector4 {
		return clone().divideCompound(other);
	}

	@:op(A % B) private inline function mod(other:Vector4):Vector4 {
		return clone().modCompound(other);
	}

	@:op(A += B) private function addFloatCompound(other:Float):Vector4 {
		this.x += other;
		this.y += other;
		this.z += other;
		this.w += other;
		return this;
	}

	@:op(A -= B) private function subtractFloatCompound(other:Float):Vector4 {
		this.x -= other;
		this.y -= other;
		this.z -= other;
		this.w -= other;
		return this;
	}

	@:op(A *= B) private function multiplyFloatCompound(other:Float):Vector4 {
		this.x *= other;
		this.y *= other;
		this.z *= other;
		this.w *= other;
		return this;
	}

	@:op(A /= B) private function divideFloatCompound(other:Float):Vector4 {
		this.x /= other;
		this.y /= other;
		this.z /= other;
		this.w /= other;
		return this;
	}

	@:op(A %= B) private function modFloatCompound(other:Float):Vector4 {
		this.x %= other;
		this.y %= other;
		this.z %= other;
		this.w %= other;
		return this;
	}

	@:op(A + B) private inline function addFloat(other:Float):Vector4 {
		return clone().addFloatCompound(other);
	}

	@:op(A - B) private inline function substractFloat(other:Float):Vector4 {
		return clone().subtractFloatCompound(other);
	}

	@:op(A * B) private inline function multiplyFloat(other:Float):Vector4 {
		return clone().multiplyFloatCompound(other);
	}

	@:op(A / B) private inline function divideFloat(other:Float):Vector4 {
		return clone().divideFloatCompound(other);
	}

	@:op(A % B) private inline function modFloat(other:Float):Vector4 {
		return clone().modFloatCompound(other);
	}

	// #endregion
	// #region constants

	public static inline function zero():Vector4 {
		return new Vector4(0.0, 0.0, 0.0, 0.0);
	}

	public static inline function one():Vector4 {
		return new Vector4(1.0, 1.0, 1.0, 1.0);
	}

	// #endregion
}
