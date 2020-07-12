use num_traits::Float;
use std::cmp::*;
use std::ops::*;

/// Representation of 3D vectors and points
#[derive(Debug, Clone, Copy)]
pub struct Vector3<T: Copy = f32> {
    pub x: T,
    pub y: T,
    pub z: T,
}

impl<T: Copy> Vector3<T> {
    /// Creates a new `Vector3` with given `x` and `y` components.
    #[inline]
    pub fn new<U: Into<T>, V: Into<T>, W: Into<T>>(x: U, y: V, z: W) -> Self {
        Self {
            x: x.into(),
            y: y.into(),
            z: z.into(),
        }
    }

    /// Converts this `Vector3<T>` to `Vector<U>`.
    #[inline]
    pub fn con<U: Copy + From<T>>(&self) -> Vector3<U> {
        Vector3::<U> {
            x: U::from(self.x),
            y: U::from(self.y),
            z: U::from(self.z),
        }
    }

    /// Copies values from `from` Vector.
    #[inline]
    pub fn copy(&mut self, from: &Self) -> &mut Self {
        self.x = from.x;
        self.y = from.y;
        self
    }

    /// Set both `x` and `y` components of this `Vector3`.
    #[inline]
    pub fn set<U: Into<T>, V: Into<T>, W: Into<T>>(&mut self, x: U, y: V, z: W) -> &mut Self {
        self.x = x.into();
        self.y = y.into();
        self.z = z.into();
        self
    }

    /// Returns the squared magnitude of this Vector.
    pub fn sq_mag<U: Float>(&self) -> U
    where
        T: Into<U>,
    {
        let x = self.x.into();
        let y = self.y.into();
        let z = self.z.into();
        x * x + y * y + z * z
    }

    /// Returns the magnitude of this Vector.
    #[inline]
    pub fn mag<U: Float>(&self) -> U
    where
        T: Into<U>,
    {
        self.sq_mag().sqrt()
    }

    /// Sets the magnitude of this Vector.
    pub fn set_mag<U: Float + Into<T>>(&mut self, mag: U) -> &mut Self
    where
        T: Float + MulAssign,
    {
        let current = self.mag::<T>();
        if current != T::zero() {
            *self *= mag.into() / current;
        }
        self
    }

    /// Normalizes this `Vector3`.
    pub fn norm(&mut self) -> &mut Self
    where
        T: Float + DivAssign,
    {
        *self /= self.mag::<T>();
        self
    }

    /// Returns a normalized clone of this `Vector3`.
    pub fn norm_clone(&self) -> Self
    where
        T: Float,
    {
        (*self / self.mag::<T>()).clone()
    }

    /// Swaps values between two Vectors.
    pub fn swap(a: &mut Self, b: &mut Self) {
        let x = a.x;
        let y = a.y;
        let z = a.z;
        a.copy(b);
        b.set(x, y, z);
    }

    /// Returns a dot product of two Vectors.
    #[inline]
    pub fn dot<U: Float>(a: &Self, b: &Self) -> U
    where
        T: Into<U>,
    {
        a.x.into() * b.x.into() + a.y.into() * b.y.into() + a.z.into() * b.z.into()
    }

    /// Returns a cross product of two Vectors.
    pub fn cross<U: Float + From<T>>(a: &Self, b: &Self) -> Vector3<U> {
        let a = a.con::<U>();
        let b = b.con::<U>();
        Vector3::<U> {
            x: a.y * b.z - a.z * b.y,
            y: a.z * b.x - a.x * b.z,
            z: a.x * b.y - a.y * b.x,
        }
    }

    /// Returns the distance between `a` and `b`.
    pub fn dist<U: Float>(from: &Self, to: &Self) -> U
    where
        T: Into<U>,
    {
        let x = to.x.into() - from.x.into();
        let y = to.y.into() - from.y.into();
        let z = to.z.into() - from.z.into();
        (x * x + y * y + z * z).sqrt()
    }

    /// Returns the angle in degrees between `from` and `to`.
    pub fn angle<U: Float>(from: &Self, to: &Self) -> U
    where
        T: Into<U>,
    {
        (Self::dot(from, to) / (from.mag() * to.mag())).acos()
    }

    /// Linearly interpolates between `from` and `to` by `t`.
    pub fn lerp<U: Float + From<T>, V: Into<U>>(from: &Self, to: &Self, t: V) -> Vector3<U> {
        let from = from.con::<U>();
        from + (to.con::<U>() - from) * t.into().min(U::one()).max(U::zero())
    }

    /// Spherically interpolates between `from` and `to` by `t`.
    pub fn slerp<U: Float + From<T>, V: Into<U>>(from: &Self, to: &Self, t: V) -> Vector3<U> {
        let from = from.con::<U>();
        let to = to.con::<U>();
        let dot = Vector3::<U>::dot::<U>(&from, &to);
        let theta = dot.acos() * t.into();
        from * theta.cos() + (to - from * dot).norm_clone() * theta.sin()
    }

    /// Moves a point `current` towards `target`.
    pub fn toward<U: Float + From<T>, V: Into<U>>(
        current: &Self,
        target: &Self,
        max_dist: V,
    ) -> Vector3<U>
    where
        T: Float,
    {
        let current = current.con::<U>();
        let target = target.con::<U>();
        let delta = target - current;
        let sq_mag = delta.sq_mag::<U>();
        let max_dist = max_dist.into();
        if sq_mag == U::zero() || (max_dist >= U::zero() && sq_mag <= max_dist * max_dist) {
            target
        } else {
            current + delta / sq_mag.sqrt() * max_dist
        }
    }

    /// Inverses the values of this Vector.
    #[inline]
    pub fn inv(&mut self) -> &mut Self
    where
        T: Neg<Output = T>,
    {
        self.x = -self.x;
        self.y = -self.y;
        self.z = -self.z;
        self
    }

    /// Returns a inversed clone of this Vector.
    #[inline]
    pub fn inv_clone(self) -> Self
    where
        T: Neg<Output = T>,
    {
        Self {
            x: -self.x,
            y: -self.y,
            z: -self.z,
        }
    }
}

impl Vector3<i8> {
    /// Shorthand for `Vector3::<i8>::new(0, 0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i8>::new(1, 1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1, z: 01 }
    }

    /// Shorthand for `Vector3::<i8>::new(-1, 0, 0)`.
    #[inline]
    pub fn left() -> Self {
        Self { x: -1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i8>::new(1, 0, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i8>::new(0, -1, 0)`.
    #[inline]
    pub fn down() -> Self {
        Self { x: 0, y: -1, z: 0 }
    }

    /// Shorthand for `Vector3::<i8>::new(0, 1, 0)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1, z: 0 }
    }

    /// Shorthand for `Vector3::<i8>::new(0, 0, -1)`.
    #[inline]
    pub fn back() -> Self {
        Self { x: 0, y: 0, z: -1 }
    }

    /// Shorthand for `Vector3::<i8>::new(0, 0, 1)`.
    #[inline]
    pub fn forw() -> Self {
        Self { x: 0, y: 0, z: 1 }
    }
}

impl Vector3<u8> {
    /// Shorthand for `Vector3::<u8>::new(0, 0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<u8>::new(1, 1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1, z: 1 }
    }

    /// Shorthand for `Vector3::<u8>::new(1, 0, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<u8>::new(0, 1, 0)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1, z: 0 }
    }

    /// Shorthand for `Vector3::<u8>::new(0, 0, 1)`.
    #[inline]
    pub fn forw() -> Self {
        Self { x: 0, y: 0, z: 1 }
    }
}

impl Vector3<i16> {
    /// Shorthand for `Vector3::<i16>::new(0, 0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i16>::new(1, 1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1, z: 01 }
    }

    /// Shorthand for `Vector3::<i16>::new(-1, 0, 0)`.
    #[inline]
    pub fn left() -> Self {
        Self { x: -1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i16>::new(1, 0, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i16>::new(0, -1, 0)`.
    #[inline]
    pub fn down() -> Self {
        Self { x: 0, y: -1, z: 0 }
    }

    /// Shorthand for `Vector3::<i16>::new(0, 1, 0)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1, z: 0 }
    }

    /// Shorthand for `Vector3::<i16>::new(0, 0, -1)`.
    #[inline]
    pub fn back() -> Self {
        Self { x: 0, y: 0, z: -1 }
    }

    /// Shorthand for `Vector3::<i16>::new(0, 0, 1)`.
    #[inline]
    pub fn forw() -> Self {
        Self { x: 0, y: 0, z: 1 }
    }
}

impl Vector3<u16> {
    /// Shorthand for `Vector3::<u16>::new(0, 0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<u16>::new(1, 1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1, z: 1 }
    }

    /// Shorthand for `Vector3::<u16>::new(1, 0, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<u16>::new(0, 1, 0)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1, z: 0 }
    }

    /// Shorthand for `Vector3::<u16>::new(0, 0, 1)`.
    #[inline]
    pub fn forw() -> Self {
        Self { x: 0, y: 0, z: 1 }
    }
}

impl Vector3<i32> {
    /// Shorthand for `Vector3::<i32>::new(0, 0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i32>::new(1, 1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1, z: 01 }
    }

    /// Shorthand for `Vector3::<i32>::new(-1, 0, 0)`.
    #[inline]
    pub fn left() -> Self {
        Self { x: -1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i32>::new(1, 0, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i32>::new(0, -1, 0)`.
    #[inline]
    pub fn down() -> Self {
        Self { x: 0, y: -1, z: 0 }
    }

    /// Shorthand for `Vector3::<i32>::new(0, 1, 0)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1, z: 0 }
    }

    /// Shorthand for `Vector3::<i32>::new(0, 0, -1)`.
    #[inline]
    pub fn back() -> Self {
        Self { x: 0, y: 0, z: -1 }
    }

    /// Shorthand for `Vector3::<i32>::new(0, 0, 1)`.
    #[inline]
    pub fn forw() -> Self {
        Self { x: 0, y: 0, z: 1 }
    }
}

impl Vector3<u32> {
    /// Shorthand for `Vector3::<u32>::new(0, 0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<u32>::new(1, 1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1, z: 1 }
    }

    /// Shorthand for `Vector3::<u32>::new(1, 0, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<u32>::new(0, 1, 0)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1, z: 0 }
    }

    /// Shorthand for `Vector3::<u32>::new(0, 0, 1)`.
    #[inline]
    pub fn forw() -> Self {
        Self { x: 0, y: 0, z: 1 }
    }
}

impl Vector3<i64> {
    /// Shorthand for `Vector3::<i64>::new(0, 0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i64>::new(1, 1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1, z: 01 }
    }

    /// Shorthand for `Vector3::<i64>::new(-1, 0, 0)`.
    #[inline]
    pub fn left() -> Self {
        Self { x: -1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i64>::new(1, 0, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i64>::new(0, -1, 0)`.
    #[inline]
    pub fn down() -> Self {
        Self { x: 0, y: -1, z: 0 }
    }

    /// Shorthand for `Vector3::<i64>::new(0, 1, 0)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1, z: 0 }
    }

    /// Shorthand for `Vector3::<i64>::new(0, 0, -1)`.
    #[inline]
    pub fn back() -> Self {
        Self { x: 0, y: 0, z: -1 }
    }

    /// Shorthand for `Vector3::<i64>::new(0, 0, 1)`.
    #[inline]
    pub fn forw() -> Self {
        Self { x: 0, y: 0, z: 1 }
    }
}

impl Vector3<u64> {
    /// Shorthand for `Vector3::<u64>::new(0, 0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<u64>::new(1, 1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1, z: 1 }
    }

    /// Shorthand for `Vector3::<u64>::new(1, 0, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<u64>::new(0, 1, 0)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1, z: 0 }
    }

    /// Shorthand for `Vector3::<u64>::new(0, 0, 1)`.
    #[inline]
    pub fn forw() -> Self {
        Self { x: 0, y: 0, z: 1 }
    }
}

impl Vector3<i128> {
    /// Shorthand for `Vector3::<i128>::new(0, 0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i128>::new(1, 1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1, z: 01 }
    }

    /// Shorthand for `Vector3::<i128>::new(-1, 0, 0)`.
    #[inline]
    pub fn left() -> Self {
        Self { x: -1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i128>::new(1, 0, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<i128>::new(0, -1, 0)`.
    #[inline]
    pub fn down() -> Self {
        Self { x: 0, y: -1, z: 0 }
    }

    /// Shorthand for `Vector3::<i128>::new(0, 1, 0)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1, z: 0 }
    }

    /// Shorthand for `Vector3::<i128>::new(0, 0, -1)`.
    #[inline]
    pub fn back() -> Self {
        Self { x: 0, y: 0, z: -1 }
    }

    /// Shorthand for `Vector3::<i128>::new(0, 0, 1)`.
    #[inline]
    pub fn forw() -> Self {
        Self { x: 0, y: 0, z: 1 }
    }
}

impl Vector3<u128> {
    /// Shorthand for `Vector3::<u128>::new(0, 0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<u128>::new(1, 1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1, z: 1 }
    }

    /// Shorthand for `Vector3::<u128>::new(1, 0, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0, z: 0 }
    }

    /// Shorthand for `Vector3::<u128>::new(0, 1, 0)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1, z: 0 }
    }

    /// Shorthand for `Vector3::<u128>::new(0, 0, 1)`.
    #[inline]
    pub fn forw() -> Self {
        Self { x: 0, y: 0, z: 1 }
    }
}

impl Vector3<f32> {
    /// Shorthand for `Vector3::<f32>::new(0.0, 0.0, 0.0)`.
    #[inline]
    pub fn zero() -> Self {
        Self {
            x: 0.0,
            y: 0.0,
            z: 0.0,
        }
    }

    /// Shorthand for `Vector3::<f32>::new(1.0, 1.0, 1.0)`.
    #[inline]
    pub fn one() -> Self {
        Self {
            x: 1.0,
            y: 1.0,
            z: 1.0,
        }
    }

    /// Shorthand for `Vector3::<f32>::new(-1.0, 0.0, 0.0)`.
    #[inline]
    pub fn left() -> Self {
        Self {
            x: -1.0,
            y: 0.0,
            z: 0.0,
        }
    }

    /// Shorthand for `Vector3::<f32>::new(1.0, 0.0, 0.0)`.
    #[inline]
    pub fn right() -> Self {
        Self {
            x: 1.0,
            y: 0.0,
            z: 0.0,
        }
    }

    /// Shorthand for `Vector3::<f32>::new(0.0, -1.0, 0.0)`.
    #[inline]
    pub fn down() -> Self {
        Self {
            x: 0.0,
            y: -1.0,
            z: 0.0,
        }
    }

    /// Shorthand for `Vector3::<f32>::new(0.0, 1.0, 0.0)`.
    #[inline]
    pub fn up() -> Self {
        Self {
            x: 0.0,
            y: 1.0,
            z: 0.0,
        }
    }

    /// Shorthand for `Vector3::<f32>::new(0.0, 0.0, -1.0)`.
    #[inline]
    pub fn back() -> Self {
        Self {
            x: 0.0,
            y: 0.0,
            z: -1.0,
        }
    }

    /// Shorthand for `Vector3::<f32>::new(0.0, 0.0, 1.0)`.
    #[inline]
    pub fn forw() -> Self {
        Self {
            x: 0.0,
            y: 0.0,
            z: 1.0,
        }
    }
}

impl Vector3<f64> {
    /// Shorthand for `Vector3::<f64>::new(0.0, 0.0, 0.0)`.
    #[inline]
    pub fn zero() -> Self {
        Self {
            x: 0.0,
            y: 0.0,
            z: 0.0,
        }
    }

    /// Shorthand for `Vector3::<f64>::new(1.0, 1.0, 1.0)`.
    #[inline]
    pub fn one() -> Self {
        Self {
            x: 1.0,
            y: 1.0,
            z: 1.0,
        }
    }

    /// Shorthand for `Vector3::<f64>::new(-1.0, 0.0, 0.0)`.
    #[inline]
    pub fn left() -> Self {
        Self {
            x: -1.0,
            y: 0.0,
            z: 0.0,
        }
    }

    /// Shorthand for `Vector3::<f64>::new(1.0, 0.0, 0.0)`.
    #[inline]
    pub fn right() -> Self {
        Self {
            x: 1.0,
            y: 0.0,
            z: 0.0,
        }
    }

    /// Shorthand for `Vector3::<f64>::new(0.0, -1.0, 0.0)`.
    #[inline]
    pub fn down() -> Self {
        Self {
            x: 0.0,
            y: -1.0,
            z: 0.0,
        }
    }

    /// Shorthand for `Vector3::<f64>::new(0.0, 1.0, 0.0)`.
    #[inline]
    pub fn up() -> Self {
        Self {
            x: 0.0,
            y: 1.0,
            z: 0.0,
        }
    }

    /// Shorthand for `Vector3::<f64>::new(0.0, 0.0, -1.0)`.
    #[inline]
    pub fn back() -> Self {
        Self {
            x: 0.0,
            y: 0.0,
            z: -1.0,
        }
    }

    /// Shorthand for `Vector3::<f64>::new(0.0, 0.0, 1.0)`.
    #[inline]
    pub fn forw() -> Self {
        Self {
            x: 0.0,
            y: 0.0,
            z: 1.0,
        }
    }
}

// Vector3<T> == Vector3<T>, Vector3<T> != Vector3<T>
impl<T: Copy + PartialEq> PartialEq for Vector3<T> {
    #[inline]
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y && self.z == other.z
    }

    #[inline]
    fn ne(&self, other: &Self) -> bool {
        self.x != other.x || self.y != other.y || self.z != other.z
    }
}

impl<T: Copy + PartialEq> Eq for Vector3<T> {}

// Vector3<T> + Vector3<T>
impl<T: Copy + Add<Output = T>> Add for Vector3<T> {
    type Output = Self;

    #[inline]
    fn add(self, other: Self) -> Self {
        Self {
            x: self.x + other.x,
            y: self.y + other.y,
            z: self.z + other.z,
        }
    }
}

// Vector3<T> += Vector3<T>
impl<T: Copy + AddAssign> AddAssign for Vector3<T> {
    #[inline]
    fn add_assign(&mut self, other: Self) {
        self.x += other.x;
        self.y += other.y;
        self.z += other.z;
    }
}

// Vector3<T> + T
impl<T: Copy + Add<Output = T>> Add<T> for Vector3<T> {
    type Output = Self;

    #[inline]
    fn add(self, other: T) -> Self {
        let other = other.into();
        Self {
            x: self.x + other,
            y: self.y + other,
            z: self.z + other,
        }
    }
}

// Vector3 += T
impl<T: Copy + AddAssign> AddAssign<T> for Vector3<T> {
    #[inline]
    fn add_assign(&mut self, other: T) {
        self.x += other;
        self.y += other;
        self.z += other;
    }
}

// Vector3<T> - Vector3<T>
impl<T: Copy + Sub<Output = T>> Sub for Vector3<T> {
    type Output = Self;

    #[inline]
    fn sub(self, other: Self) -> Self {
        Self {
            x: self.x - other.x,
            y: self.y - other.y,
            z: self.z - other.z,
        }
    }
}

// Vector3<T> -= Vector3<T>
impl<T: Copy + SubAssign> SubAssign for Vector3<T> {
    #[inline]
    fn sub_assign(&mut self, other: Self) {
        self.x -= other.x;
        self.y -= other.y;
        self.z -= other.z;
    }
}

// Vector3<T> - T
impl<T: Copy + Sub<Output = T>> Sub<T> for Vector3<T> {
    type Output = Self;

    #[inline]
    fn sub(self, other: T) -> Self {
        Self {
            x: self.x - other,
            y: self.y - other,
            z: self.z - other,
        }
    }
}

// Vector3<T> -= T
impl<T: Copy + SubAssign> SubAssign<T> for Vector3<T> {
    #[inline]
    fn sub_assign(&mut self, other: T) {
        self.x -= other;
        self.y -= other;
        self.z -= other;
    }
}

// Vector3<T> * Vector3<T>
impl<T: Copy + Mul<Output = T>> Mul for Vector3<T> {
    type Output = Self;

    #[inline]
    fn mul(self, other: Self) -> Self {
        Self {
            x: self.x * other.x,
            y: self.y * other.y,
            z: self.z * other.z,
        }
    }
}

// Vector3<T> *= Vector3<T>
impl<T: Copy + MulAssign> MulAssign for Vector3<T> {
    #[inline]
    fn mul_assign(&mut self, other: Self) {
        self.x *= other.x;
        self.y *= other.y;
        self.z *= other.z;
    }
}

// Vector3<T> * T
impl<T: Copy + Mul<Output = T>> Mul<T> for Vector3<T> {
    type Output = Self;

    #[inline]
    fn mul(self, other: T) -> Self {
        Self {
            x: self.x * other,
            y: self.y * other,
            z: self.z * other,
        }
    }
}

// Vector3<T> *= T
impl<T: Copy + MulAssign> MulAssign<T> for Vector3<T> {
    #[inline]
    fn mul_assign(&mut self, other: T) {
        self.x *= other;
        self.y *= other;
        self.z *= other;
    }
}

// Vector3<T> / Vector3<T>
impl<T: Copy + Div<Output = T>> Div for Vector3<T> {
    type Output = Self;

    #[inline]
    fn div(self, other: Self) -> Self {
        Self {
            x: self.x / other.x,
            y: self.y / other.y,
            z: self.z / other.z,
        }
    }
}

// Vector3<T> /= Vector3<T>
impl<T: Copy + DivAssign> DivAssign for Vector3<T> {
    #[inline]
    fn div_assign(&mut self, other: Self) {
        self.x /= other.x;
        self.y /= other.y;
        self.z /= other.z;
    }
}

// Vector3<T> / T
impl<T: Copy + Div<Output = T>> Div<T> for Vector3<T> {
    type Output = Self;

    #[inline]
    fn div(self, other: T) -> Self {
        Self {
            x: self.x / other,
            y: self.y / other,
            z: self.z / other,
        }
    }
}

// Vector3<T> /= T
impl<T: Copy + DivAssign> DivAssign<T> for Vector3<T> {
    #[inline]
    fn div_assign(&mut self, other: T) {
        let other = other.into();
        self.x /= other;
        self.y /= other;
        self.z /= other;
    }
}

// Vector3<T> % Vector3<T>
impl<T: Copy + Rem<Output = T>> Rem for Vector3<T> {
    type Output = Self;

    #[inline]
    fn rem(self, other: Self) -> Self {
        Self {
            x: self.x % other.x,
            y: self.y % other.y,
            z: self.z % other.z,
        }
    }
}

// Vector3<T> %= Vector3<T>
impl<T: Copy + RemAssign> RemAssign for Vector3<T> {
    #[inline]
    fn rem_assign(&mut self, other: Self) {
        self.x %= other.x;
        self.y %= other.y;
        self.z %= other.z;
    }
}

// Vector3<T> % T
impl<T: Copy + Rem<Output = T>> Rem<T> for Vector3<T> {
    type Output = Self;

    #[inline]
    fn rem(self, other: T) -> Self {
        Self {
            x: self.x % other,
            y: self.y % other,
            z: self.z % other,
        }
    }
}

// Vector3<T> %= T
impl<T: Copy + RemAssign> RemAssign<T> for Vector3<T> {
    #[inline]
    fn rem_assign(&mut self, other: T) {
        self.x %= other;
        self.y %= other;
        self.z %= other;
    }
}

// -Vector3<T>
impl<T: Copy + Neg<Output = T>> Neg for Vector3<T> {
    type Output = Self;

    #[inline]
    fn neg(self) -> Self {
        Self {
            x: -self.x,
            y: -self.y,
            z: -self.z,
        }
    }
}
