pub struct Matrix4([f32; 16]);

impl Matrix4 {
    pub fn new() -> Self {
        Self {
            0: [
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            ],
        }
    }

    pub fn clear(&mut self) {
        self.0 = [
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        ];
    }

    pub fn copy(&mut self, from: Self) {
        self.0[0] = from.0[0];
        self.0[1] = from.0[1];
        self.0[2] = from.0[2];
        self.0[3] = from.0[3];
        self.0[4] = from.0[4];
        self.0[5] = from.0[5];
        self.0[6] = from.0[6];
        self.0[7] = from.0[7];
        self.0[8] = from.0[8];
        self.0[9] = from.0[9];
        self.0[10] = from.0[10];
        self.0[11] = from.0[11];
        self.0[12] = from.0[12];
        self.0[13] = from.0[13];
        self.0[14] = from.0[14];
        self.0[15] = from.0[15];
    }

    pub fn inv(&mut self) {
        let m00 = self.0[0];
        let m01 = self.0[1];
        let m02 = self.0[2];
        let m03 = self.0[3];
        let m10 = self.0[4];
        let m11 = self.0[5];
        let m12 = self.0[6];
        let m13 = self.0[7];
        let m20 = self.0[8];
        let m21 = self.0[9];
        let m22 = self.0[10];
        let m23 = self.0[11];
        let m30 = self.0[12];
        let m31 = self.0[13];
        let m32 = self.0[14];
        let m33 = self.0[15];
        let tm0 = m22 * m33;
        let tm1 = m32 * m23;
        let tm2 = m12 * m33;
        let tm3 = m32 * m13;
        let tm4 = m12 * m23;
        let tm5 = m22 * m13;
        let tm6 = m02 * m33;
        let tm7 = m32 * m03;
        let tm8 = m02 * m23;
        let tm9 = m22 * m03;
        let tm10 = m02 * m13;
        let tm11 = m12 * m03;
        let tm12 = m20 * m31;
        let tm13 = m30 * m21;
        let tm14 = m10 * m31;
        let tm15 = m30 * m11;
        let tm16 = m10 * m21;
        let tm17 = m20 * m11;
        let tm18 = m00 * m31;
        let tm19 = m30 * m01;
        let tm20 = m00 * m21;
        let tm21 = m20 * m01;
        let tm22 = m00 * m11;
        let tm23 = m10 * m01;
        let t0 = (tm0 * m11 + tm3 * m21 + tm4 * m31) - (tm1 * m11 + tm2 * m21 + tm5 * m31);
        let t1 = (tm1 * m01 + tm6 * m21 + tm9 * m31) - (tm0 * m01 + tm7 * m21 + tm8 * m31);
        let t2 = (tm2 * m01 + tm7 * m11 + tm10 * m31) - (tm3 * m01 + tm6 * m11 + tm11 * m31);
        let t3 = (tm5 * m01 + tm8 * m11 + tm11 * m21) - (tm4 * m01 + tm9 * m11 + tm10 * m21);
        let d = 1.0 / (m00 * t0 + m10 * t1 + m20 * t2 + m30 * t3);
        self.0[0] = d * t0;
        self.0[1] = d * t1;
        self.0[2] = d * t2;
        self.0[3] = d * t3;
        self.0[4] = d * ((tm1 * m10 + tm2 * m20 + tm5 * m30) - (tm0 * m10 + tm3 * m20 + tm4 * m30));
        self.0[5] = d * ((tm0 * m00 + tm7 * m20 + tm8 * m30) - (tm1 * m00 + tm6 * m20 + tm9 * m30));
        self.0[6] =
            d * ((tm3 * m00 + tm6 * m10 + tm11 * m30) - (tm2 * m00 + tm7 * m10 + tm10 * m30));
        self.0[7] =
            d * ((tm4 * m00 + tm9 * m10 + tm10 * m20) - (tm5 * m00 + tm8 * m10 + tm11 * m20));
        self.0[8] =
            d * ((tm12 * m13 + tm15 * m23 + tm16 * m33) - (tm13 * m13 + tm14 * m23 + tm17 * m33));
        self.0[9] =
            d * ((tm13 * m03 + tm18 * m23 + tm21 * m33) - (tm12 * m03 + tm19 * m23 + tm20 * m33));
        self.0[10] =
            d * ((tm14 * m03 + tm19 * m13 + tm22 * m33) - (tm15 * m03 + tm18 * m13 + tm23 * m33));
        self.0[11] =
            d * ((tm17 * m03 + tm20 * m13 + tm23 * m23) - (tm16 * m03 + tm21 * m13 + tm22 * m23));
        self.0[12] =
            d * ((tm14 * m22 + tm17 * m32 + tm13 * m12) - (tm16 * m32 + tm12 * m12 + tm15 * m22));
        self.0[13] =
            d * ((tm20 * m32 + tm12 * m02 + tm19 * m22) - (tm18 * m22 + tm21 * m32 + tm13 * m02));
        self.0[14] =
            d * ((tm18 * m12 + tm23 * m32 + tm15 * m02) - (tm22 * m32 + tm14 * m02 + tm19 * m12));
        self.0[15] =
            d * ((tm22 * m22 + tm16 * m02 + tm21 * m12) - (tm20 * m12 + tm23 * m22 + tm17 * m02));
    }

    pub fn inv_clone(&self) -> Self {
        Self::new()
    }
}

impl std::ops::Mul for Matrix4 {
    type Output = Matrix4;

    fn mul(self, other: Self) -> Self {
        let a00 = self.0[0];
        let a01 = self.0[1];
        let a02 = self.0[2];
        let a03 = self.0[3];
        let a10 = self.0[4];
        let a11 = self.0[5];
        let a12 = self.0[6];
        let a13 = self.0[7];
        let a20 = self.0[8];
        let a21 = self.0[9];
        let a22 = self.0[10];
        let a23 = self.0[11];
        let a30 = self.0[12];
        let a31 = self.0[13];
        let a32 = self.0[14];
        let a33 = self.0[15];
        let b00 = other.0[0];
        let b01 = other.0[1];
        let b02 = other.0[2];
        let b03 = other.0[3];
        let b10 = other.0[4];
        let b11 = other.0[5];
        let b12 = other.0[6];
        let b13 = other.0[7];
        let b20 = other.0[8];
        let b21 = other.0[9];
        let b22 = other.0[10];
        let b23 = other.0[11];
        let b30 = other.0[12];
        let b31 = other.0[13];
        let b32 = other.0[14];
        let b33 = other.0[15];
        Self {
            0: [
                b00 * a00 + b01 * a10 + b02 * a20 + b03 * a30,
                b00 * a01 + b01 * a11 + b02 * a21 + b03 * a31,
                b00 * a02 + b01 * a12 + b02 * a22 + b03 * a32,
                b00 * a03 + b01 * a13 + b02 * a23 + b03 * a33,
                b10 * a00 + b11 * a10 + b12 * a20 + b13 * a30,
                b10 * a01 + b11 * a11 + b12 * a21 + b13 * a31,
                b10 * a02 + b11 * a12 + b12 * a22 + b13 * a32,
                b10 * a03 + b11 * a13 + b12 * a23 + b13 * a33,
                b20 * a00 + b21 * a10 + b22 * a20 + b23 * a30,
                b20 * a01 + b21 * a11 + b22 * a21 + b23 * a31,
                b20 * a02 + b21 * a12 + b22 * a22 + b23 * a32,
                b20 * a03 + b21 * a13 + b22 * a23 + b23 * a33,
                b30 * a00 + b31 * a10 + b32 * a20 + b33 * a30,
                b30 * a01 + b31 * a11 + b32 * a21 + b33 * a31,
                b30 * a02 + b31 * a12 + b32 * a22 + b33 * a32,
                b30 * a03 + b31 * a13 + b32 * a23 + b33 * a33,
            ],
        }
    }
}

impl std::ops::MulAssign for Matrix4 {
    fn mul_assign(&mut self, other: Self) {
        self.0 = [
            self.0[0] * other.0[0]
                + self.0[1] * other.0[4]
                + self.0[2] * other.0[8]
                + self.0[3] * other.0[12],
            self.0[0] * other.0[1]
                + self.0[1] * other.0[5]
                + self.0[2] * other.0[9]
                + self.0[3] * other.0[13],
            self.0[0] * other.0[2]
                + self.0[1] * other.0[6]
                + self.0[2] * other.0[10]
                + self.0[3] * other.0[14],
            self.0[0] * other.0[3]
                + self.0[1] * other.0[7]
                + self.0[2] * other.0[11]
                + self.0[3] * other.0[15],
            self.0[4] * other.0[0]
                + self.0[5] * other.0[4]
                + self.0[6] * other.0[8]
                + self.0[7] * other.0[12],
            self.0[4] * other.0[1]
                + self.0[5] * other.0[5]
                + self.0[6] * other.0[9]
                + self.0[7] * other.0[13],
            self.0[4] * other.0[2]
                + self.0[5] * other.0[6]
                + self.0[6] * other.0[10]
                + self.0[7] * other.0[14],
            self.0[4] * other.0[3]
                + self.0[5] * other.0[7]
                + self.0[6] * other.0[11]
                + self.0[7] * other.0[15],
            self.0[8] * other.0[0]
                + self.0[9] * other.0[4]
                + self.0[10] * other.0[8]
                + self.0[11] * other.0[12],
            self.0[8] * other.0[1]
                + self.0[9] * other.0[5]
                + self.0[10] * other.0[9]
                + self.0[11] * other.0[13],
            self.0[8] * other.0[2]
                + self.0[9] * other.0[6]
                + self.0[10] * other.0[10]
                + self.0[11] * other.0[14],
            self.0[8] * other.0[3]
                + self.0[9] * other.0[7]
                + self.0[10] * other.0[11]
                + self.0[11] * other.0[15],
            self.0[12] * other.0[0]
                + self.0[13] * other.0[4]
                + self.0[14] * other.0[8]
                + self.0[15] * other.0[12],
            self.0[12] * other.0[1]
                + self.0[13] * other.0[5]
                + self.0[14] * other.0[9]
                + self.0[15] * other.0[13],
            self.0[12] * other.0[2]
                + self.0[13] * other.0[6]
                + self.0[14] * other.0[10]
                + self.0[15] * other.0[14],
            self.0[12] * other.0[3]
                + self.0[13] * other.0[7]
                + self.0[14] * other.0[11]
                + self.0[15] * other.0[15],
        ]
    }
}
