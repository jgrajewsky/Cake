package cake.engine;

abstract Matrix4x4(Array<Float>) from Array<Float> to Array<Float> {
	public inline function new() {
		this = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
	}

	// #region functions

	public function inverse():Void {
		var m00 = this[0];
		var m01 = this[1];
		var m02 = this[2];
		var m03 = this[3];
		var m10 = this[4];
		var m11 = this[5];
		var m12 = this[6];
		var m13 = this[7];
		var m20 = this[8];
		var m21 = this[9];
		var m22 = this[10];
		var m23 = this[11];
		var m30 = this[12];
		var m31 = this[13];
		var m32 = this[14];
		var m33 = this[15];
		var tm0 = m22 * m33;
		var tm1 = m32 * m23;
		var tm2 = m12 * m33;
		var tm3 = m32 * m13;
		var tm4 = m12 * m23;
		var tm5 = m22 * m13;
		var tm6 = m02 * m33;
		var tm7 = m32 * m03;
		var tm8 = m02 * m23;
		var tm9 = m22 * m03;
		var tm10 = m02 * m13;
		var tm11 = m12 * m03;
		var tm12 = m20 * m31;
		var tm13 = m30 * m21;
		var tm14 = m10 * m31;
		var tm15 = m30 * m11;
		var tm16 = m10 * m21;
		var tm17 = m20 * m11;
		var tm18 = m00 * m31;
		var tm19 = m30 * m01;
		var tm20 = m00 * m21;
		var tm21 = m20 * m01;
		var tm22 = m00 * m11;
		var tm23 = m10 * m01;
		var t0 = (tm0 * m11 + tm3 * m21 + tm4 * m31) - (tm1 * m11 + tm2 * m21 + tm5 * m31);
		var t1 = (tm1 * m01 + tm6 * m21 + tm9 * m31) - (tm0 * m01 + tm7 * m21 + tm8 * m31);
		var t2 = (tm2 * m01 + tm7 * m11 + tm10 * m31) - (tm3 * m01 + tm6 * m11 + tm11 * m31);
		var t3 = (tm5 * m01 + tm8 * m11 + tm11 * m21) - (tm4 * m01 + tm9 * m11 + tm10 * m21);
		var d = 1.0 / (m00 * t0 + m10 * t1 + m20 * t2 + m30 * t3);
		this[0] = d * t0;
		this[1] = d * t1;
		this[2] = d * t2;
		this[3] = d * t3;
		this[4] = d * ((tm1 * m10 + tm2 * m20 + tm5 * m30) - (tm0 * m10 + tm3 * m20 + tm4 * m30));
		this[5] = d * ((tm0 * m00 + tm7 * m20 + tm8 * m30) - (tm1 * m00 + tm6 * m20 + tm9 * m30));
		this[6] = d * ((tm3 * m00 + tm6 * m10 + tm11 * m30) - (tm2 * m00 + tm7 * m10 + tm10 * m30));
		this[7] = d * ((tm4 * m00 + tm9 * m10 + tm10 * m20) - (tm5 * m00 + tm8 * m10 + tm11 * m20));
		this[8] = d * ((tm12 * m13 + tm15 * m23 + tm16 * m33) - (tm13 * m13 + tm14 * m23 + tm17 * m33));
		this[9] = d * ((tm13 * m03 + tm18 * m23 + tm21 * m33) - (tm12 * m03 + tm19 * m23 + tm20 * m33));
		this[10] = d * ((tm14 * m03 + tm19 * m13 + tm22 * m33) - (tm15 * m03 + tm18 * m13 + tm23 * m33));
		this[11] = d * ((tm17 * m03 + tm20 * m13 + tm23 * m23) - (tm16 * m03 + tm21 * m13 + tm22 * m23));
		this[12] = d * ((tm14 * m22 + tm17 * m32 + tm13 * m12) - (tm16 * m32 + tm12 * m12 + tm15 * m22));
		this[13] = d * ((tm20 * m32 + tm12 * m02 + tm19 * m22) - (tm18 * m22 + tm21 * m32 + tm13 * m02));
		this[14] = d * ((tm18 * m12 + tm23 * m32 + tm15 * m02) - (tm22 * m32 + tm14 * m02 + tm19 * m12));
		this[15] = d * ((tm22 * m22 + tm16 * m02 + tm21 * m12) - (tm20 * m12 + tm23 * m22 + tm17 * m02));
	}

	public function clear():Void {
		this[16] = this[15] = this[14] = this[13] = this[12] = this[11] = this[10] = this[9] = this[8] = this[7] = this[6] = this[5] = this[4] = this[3] = this[2] = this[1] = this[0] = 0.0;
	}

	public function copy(from:Matrix4x4):Void {
		this[0] = from[0];
		this[1] = from[1];
		this[2] = from[2];
		this[3] = from[3];
		this[4] = from[4];
		this[5] = from[5];
		this[6] = from[6];
		this[7] = from[7];
		this[8] = from[8];
		this[9] = from[9];
		this[10] = from[10];
		this[11] = from[11];
		this[12] = from[12];
		this[13] = from[13];
		this[14] = from[14];
		this[15] = from[15];
	}

	// #endregion
	// #region operators

	@:op(A *= B) private function multiplyCompound(other:Matrix4x4):Matrix4x4 {
		var a00 = this[0];
		var a01 = this[1];
		var a02 = this[2];
		var a03 = this[3];
		var a10 = this[4];
		var a11 = this[5];
		var a12 = this[6];
		var a13 = this[7];
		var a20 = this[8];
		var a21 = this[9];
		var a22 = this[10];
		var a23 = this[11];
		var a30 = this[12];
		var a31 = this[13];
		var a32 = this[14];
		var a33 = this[15];
		var b00 = other[0];
		var b01 = other[1];
		var b02 = other[2];
		var b03 = other[3];
		var b10 = other[4];
		var b11 = other[5];
		var b12 = other[6];
		var b13 = other[7];
		var b20 = other[8];
		var b21 = other[9];
		var b22 = other[10];
		var b23 = other[11];
		var b30 = other[12];
		var b31 = other[13];
		var b32 = other[14];
		var b33 = other[15];
		this[0] = b00 * a00 + b01 * a10 + b02 * a20 + b03 * a30;
		this[1] = b00 * a01 + b01 * a11 + b02 * a21 + b03 * a31;
		this[2] = b00 * a02 + b01 * a12 + b02 * a22 + b03 * a32;
		this[3] = b00 * a03 + b01 * a13 + b02 * a23 + b03 * a33;
		this[4] = b10 * a00 + b11 * a10 + b12 * a20 + b13 * a30;
		this[5] = b10 * a01 + b11 * a11 + b12 * a21 + b13 * a31;
		this[6] = b10 * a02 + b11 * a12 + b12 * a22 + b13 * a32;
		this[7] = b10 * a03 + b11 * a13 + b12 * a23 + b13 * a33;
		this[8] = b20 * a00 + b21 * a10 + b22 * a20 + b23 * a30;
		this[9] = b20 * a01 + b21 * a11 + b22 * a21 + b23 * a31;
		this[10] = b20 * a02 + b21 * a12 + b22 * a22 + b23 * a32;
		this[11] = b20 * a03 + b21 * a13 + b22 * a23 + b23 * a33;
		this[12] = b30 * a00 + b31 * a10 + b32 * a20 + b33 * a30;
		this[13] = b30 * a01 + b31 * a11 + b32 * a21 + b33 * a31;
		this[14] = b30 * a02 + b31 * a12 + b32 * a22 + b33 * a32;
		this[15] = b30 * a03 + b31 * a13 + b32 * a23 + b33 * a33;
		return this;
	}

	@:op(A * B) private function multiply(other:Matrix4x4):Matrix4x4 {
		var matrix = new Matrix4x4();
		var a00 = this[0];
		var a01 = this[1];
		var a02 = this[2];
		var a03 = this[3];
		var a10 = this[4];
		var a11 = this[5];
		var a12 = this[6];
		var a13 = this[7];
		var a20 = this[8];
		var a21 = this[9];
		var a22 = this[10];
		var a23 = this[11];
		var a30 = this[12];
		var a31 = this[13];
		var a32 = this[14];
		var a33 = this[15];
		var b00 = other[0];
		var b01 = other[1];
		var b02 = other[2];
		var b03 = other[3];
		var b10 = other[4];
		var b11 = other[5];
		var b12 = other[6];
		var b13 = other[7];
		var b20 = other[8];
		var b21 = other[9];
		var b22 = other[10];
		var b23 = other[11];
		var b30 = other[12];
		var b31 = other[13];
		var b32 = other[14];
		var b33 = other[15];
		matrix[0] = b00 * a00 + b01 * a10 + b02 * a20 + b03 * a30;
		matrix[1] = b00 * a01 + b01 * a11 + b02 * a21 + b03 * a31;
		matrix[2] = b00 * a02 + b01 * a12 + b02 * a22 + b03 * a32;
		matrix[3] = b00 * a03 + b01 * a13 + b02 * a23 + b03 * a33;
		matrix[4] = b10 * a00 + b11 * a10 + b12 * a20 + b13 * a30;
		matrix[5] = b10 * a01 + b11 * a11 + b12 * a21 + b13 * a31;
		matrix[6] = b10 * a02 + b11 * a12 + b12 * a22 + b13 * a32;
		matrix[7] = b10 * a03 + b11 * a13 + b12 * a23 + b13 * a33;
		matrix[8] = b20 * a00 + b21 * a10 + b22 * a20 + b23 * a30;
		matrix[9] = b20 * a01 + b21 * a11 + b22 * a21 + b23 * a31;
		matrix[10] = b20 * a02 + b21 * a12 + b22 * a22 + b23 * a32;
		matrix[11] = b20 * a03 + b21 * a13 + b22 * a23 + b23 * a33;
		matrix[12] = b30 * a00 + b31 * a10 + b32 * a20 + b33 * a30;
		matrix[13] = b30 * a01 + b31 * a11 + b32 * a21 + b33 * a31;
		matrix[14] = b30 * a02 + b31 * a12 + b32 * a22 + b33 * a32;
		matrix[15] = b30 * a03 + b31 * a13 + b32 * a23 + b33 * a33;
		return matrix;
	}

	@:op([]) private inline function arrayGet(index:Int):Float {
		return this[index];
	}

	@:op([]) private inline function arraySet(index:Int, value:Float):Float {
		return this[index] = value;
	}

	// #endregion
}
