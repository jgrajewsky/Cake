package cake.engine;

import kha.math.FastMatrix3;

@:forward abstract Matrix3(FastMatrix3) from FastMatrix3 to FastMatrix3 {
	public inline function new() {
		this = new FastMatrix3(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	}

	// #region functions

	public inline function clear():Void {
		this._00 = this._10 = this._20 = this._01 = this._11 = this._21 = this._02 = this._12 = this._22 = 0.0;
	}

	public function copy(from:Matrix3):Void {
		this._00 = from._00;
		this._10 = from._10;
		this._20 = from._20;
		this._01 = from._01;
		this._11 = from._11;
		this._21 = from._21;
		this._02 = from._02;
		this._12 = from._12;
		this._22 = from._22;
	}

	// #endregion
	// #region operators

	@:op(A *= B) private function multiplyCompound(other:Matrix3):Matrix3 {
		var _00 = this._00 * other._00 + this._10 * other._01 + this._20 * other._02;
		var _10 = this._00 * other._10 + this._10 * other._11 + this._20 * other._12;
		var _01 = this._01 * other._00 + this._11 * other._01 + this._21 * other._02;
		var _11 = this._01 * other._10 + this._11 * other._11 + this._21 * other._12;
		var _02 = this._02 * other._00 + this._12 * other._01 + this._22 * other._02;
		var _12 = this._02 * other._10 + this._12 * other._11 + this._22 * other._12;
		this._00 = _00;
		this._10 = _10;
		this._20 = this._00 * other._20 + this._10 * other._21 + this._20 * other._22;
		this._01 = _01;
		this._11 = _11;
		this._21 = this._01 * other._20 + this._11 * other._21 + this._21 * other._22;
		this._02 = _02;
		this._12 = _12;
		this._22 = this._02 * other._20 + this._12 * other._21 + this._22 * other._22;
		return this;
	}

	@:op(A * B) private function multiply(other:Matrix3):Matrix3 {
		return new FastMatrix3(this._00 * other._00
			+ this._10 * other._01
			+ this._20 * other._02,
			this._00 * other._10
			+ this._10 * other._11
			+ this._20 * other._12, this._00 * other._20
			+ this._10 * other._21
			+ this._20 * other._22,
			this._01 * other._00
			+ this._11 * other._01
			+ this._21 * other._02, this._01 * other._10
			+ this._11 * other._11
			+ this._21 * other._12,
			this._01 * other._20
			+ this._11 * other._21
			+ this._21 * other._22, this._02 * other._00
			+ this._12 * other._01
			+ this._22 * other._02,
			this._02 * other._10
			+ this._12 * other._11
			+ this._22 * other._12, this._02 * other._20
			+ this._12 * other._21
			+ this._22 * other._22);
	}

	// #endregion
}
