use num_traits::Float;
use std::cmp::*;
use std::ops::*;

/// Representation of 2D vectors and points
#[derive(Debug, Clone, Copy)]
pub struct Vector2<T: Copy = f32> {
    pub x: T,
    pub y: T,
}

impl<T: Copy> Vector2<T> {
    /// Creates a new `Vector2` with given `x` and `y` components.
    #[inline]
    pub fn new<U: Into<T>, V: Into<T>>(x: U, y: V) -> Self {
        Self {
            x: x.into(),
            y: y.into(),
        }
    }

    /// Converts this `Vector2<T>` to `Vector<U>`.
    #[inline]
    pub fn con<U: Copy + From<T>>(&self) -> Vector2<U> {
        Vector2::<U> {
            x: U::from(self.x),
            y: U::from(self.y),
        }
    }

    /// Copies values from `from` Vector.
    #[inline]
    pub fn copy(&mut self, from: &Self) -> &mut Self {
        self.x = from.x;
        self.y = from.y;
        self
    }

    /// Set both `x` and `y` components of this `Vector2`.
    #[inline]
    pub fn set<U: Into<T>, V: Into<T>>(&mut self, x: U, y: V) -> &mut Self {
        self.x = x.into();
        self.y = y.into();
        self
    }

    /// Returns the squared magnitude of this Vector.
    pub fn sq_mag<U: Float>(&self) -> U
    where
        T: Into<U>,
    {
        let x = self.x.into();
        let y = self.y.into();
        x * x + y * y
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

    /// Normalizes this `Vector2`.
    pub fn norm(&mut self) -> &mut Self
    where
        T: Float + DivAssign,
    {
        *self /= self.mag::<T>();
        self
    }

    /// Returns a normalized clone of this `Vector2`.
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
        a.copy(b);
        b.set(x, y);
    }

    /// Returns a dot product of two Vectors.
    #[inline]
    pub fn dot<U: Float>(a: &Self, b: &Self) -> U
    where
        T: Into<U>,
    {
        a.x.into() * b.x.into() + a.y.into() * b.y.into()
    }

    /// Returns the distance between `a` and `b`.
    pub fn dist<U: Float>(from: &Self, to: &Self) -> U
    where
        T: Into<U>,
    {
        let x = to.x.into() - from.x.into();
        let y = to.y.into() - from.y.into();
        (x * x + y * y).sqrt()
    }

    /// Returns the angle in degrees between `from` and `to`.
    pub fn angle<U: Float>(from: &Self, to: &Self) -> U
    where
        T: Into<U>,
    {
        (Self::dot(from, to) / (from.mag() * to.mag())).acos()
    }

    /// Linearly interpolates between `from` and `to` by `t`.
    pub fn lerp<U: Float + From<T>, V: Into<U>>(from: &Self, to: &Self, t: V) -> Vector2<U> {
        let from = from.con::<U>();
        from + (to.con::<U>() - from) * t.into().min(U::one()).max(U::zero())
    }

    /// Moves a point `current` towards `target`.
    pub fn toward<U: Float + From<T>, V: Into<U>>(
        current: &Self,
        target: &Self,
        max_dist: V,
    ) -> Vector2<U>
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
        }
    }
}

impl Vector2<i8> {
    /// Shorthand for `Vector2::<i8>::new(0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0 }
    }

    /// Shorthand for `Vector2::<i8>::new(1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1 }
    }

    /// Shorthand for `Vector2::<i8>::new(-1, 0)`.
    #[inline]
    pub fn left() -> Self {
        Self { x: -1, y: 0 }
    }

    /// Shorthand for `Vector2::<i8>::new(1, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0 }
    }

    /// Shorthand for `Vector2::<i8>::new(0, -1)`.
    #[inline]
    pub fn down() -> Self {
        Self { x: 0, y: -1 }
    }

    /// Shorthand for `Vector2::<i8>::new(0, 1)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1 }
    }
}

impl Vector2<u8> {
    /// Shorthand for `Vector2::<u8>::new(0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0 }
    }

    /// Shorthand for `Vector2::<u8>::new(1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1 }
    }

    /// Shorthand for `Vector2::<u8>::new(1, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0 }
    }

    /// Shorthand for `Vector2::<u8>::new(0, 1)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1 }
    }
}

impl Vector2<i16> {
    /// Shorthand for `Vector2::<i16>::new(0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0 }
    }

    /// Shorthand for `Vector2::<i16>::new(1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1 }
    }

    /// Shorthand for `Vector2::<i16>::new(-1, 0)`.
    #[inline]
    pub fn left() -> Self {
        Self { x: -1, y: 0 }
    }

    /// Shorthand for `Vector2::<i16>::new(1, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0 }
    }

    /// Shorthand for `Vector2::<i16>::new(0, -1)`.
    #[inline]
    pub fn down() -> Self {
        Self { x: 0, y: -1 }
    }

    /// Shorthand for `Vector2::<i16>::new(0, 1)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1 }
    }
}

impl Vector2<u16> {
    /// Shorthand for `Vector2::<u16>::new(0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0 }
    }

    /// Shorthand for `Vector2::<u16>::new(1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1 }
    }

    /// Shorthand for `Vector2::<u16>::new(1, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0 }
    }

    /// Shorthand for `Vector2::<u16>::new(0, 1)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1 }
    }
}

impl Vector2<i32> {
    /// Shorthand for `Vector2::<i32>::new(0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0 }
    }

    /// Shorthand for `Vector2::<i32>::new(1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1 }
    }

    /// Shorthand for `Vector2::<i32>::new(-1, 0)`.
    #[inline]
    pub fn left() -> Self {
        Self { x: -1, y: 0 }
    }

    /// Shorthand for `Vector2::<i32>::new(1, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0 }
    }

    /// Shorthand for `Vector2::<i32>::new(0, -1)`.
    #[inline]
    pub fn down() -> Self {
        Self { x: 0, y: -1 }
    }

    /// Shorthand for `Vector2::<i32>::new(0, 1)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1 }
    }
}

impl Vector2<u32> {
    /// Shorthand for `Vector2::<u32>::new(0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0 }
    }

    /// Shorthand for `Vector2::<u32>::new(1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1 }
    }

    /// Shorthand for `Vector2::<u32>::new(1, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0 }
    }

    /// Shorthand for `Vector2::<u32>::new(0, 1)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1 }
    }
}

impl Vector2<i64> {
    /// Shorthand for `Vector2::<i64>::new(0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0 }
    }

    /// Shorthand for `Vector2::<i64>::new(1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1 }
    }

    /// Shorthand for `Vector2::<i64>::new(-1, 0)`.
    #[inline]
    pub fn left() -> Self {
        Self { x: -1, y: 0 }
    }

    /// Shorthand for `Vector2::<i64>::new(1, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0 }
    }

    /// Shorthand for `Vector2::<i64>::new(0, -1)`.
    #[inline]
    pub fn down() -> Self {
        Self { x: 0, y: -1 }
    }

    /// Shorthand for `Vector2::<i64>::new(0, 1)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1 }
    }
}

impl Vector2<u64> {
    /// Shorthand for `Vector2::<u64>::new(0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0 }
    }

    /// Shorthand for `Vector2::<u64>::new(1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1 }
    }

    /// Shorthand for `Vector2::<u64>::new(1, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0 }
    }

    /// Shorthand for `Vector2::<u64>::new(0, 1)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1 }
    }
}

impl Vector2<i128> {
    /// Shorthand for `Vector2::<i128>::new(0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0 }
    }

    /// Shorthand for `Vector2::<i128>::new(1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1 }
    }

    /// Shorthand for `Vector2::<i128>::new(-1, 0)`.
    #[inline]
    pub fn left() -> Self {
        Self { x: -1, y: 0 }
    }

    /// Shorthand for `Vector2::<i128>::new(1, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0 }
    }

    /// Shorthand for `Vector2::<i128>::new(0, -1)`.
    #[inline]
    pub fn down() -> Self {
        Self { x: 0, y: -1 }
    }

    /// Shorthand for `Vector2::<i128>::new(0, 1)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1 }
    }
}

impl Vector2<u128> {
    /// Shorthand for `Vector2::<u128>::new(0, 0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0, y: 0 }
    }

    /// Shorthand for `Vector2::<u128>::new(1, 1)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1, y: 1 }
    }

    /// Shorthand for `Vector2::<u128>::new(1, 0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1, y: 0 }
    }

    /// Shorthand for `Vector2::<u128>::new(0, 1)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0, y: 1 }
    }
}

impl Vector2<f32> {
    /// Shorthand for `Vector2::<f32>::new(0.0, 0.0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0.0, y: 0.0 }
    }

    /// Shorthand for `Vector2::<f32>::new(1.0, 1.0)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1.0, y: 1.0 }
    }

    /// Shorthand for `Vector2::<f32>::new(-1.0, 0.0)`.
    #[inline]
    pub fn left() -> Self {
        Self { x: -1.0, y: 0.0 }
    }

    /// Shorthand for `Vector2::<f32>::new(1.0, 0.0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1.0, y: 0.0 }
    }

    /// Shorthand for `Vector2::<f32>::new(0.0, -1.0)`.
    #[inline]
    pub fn down() -> Self {
        Self { x: 0.0, y: -1.0 }
    }

    /// Shorthand for `Vector2::<f32>::new(0.0, 1.0)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0.0, y: 1.0 }
    }
}

impl Vector2<f64> {
    /// Shorthand for `Vector2::<f64>::new(0.0, 0.0)`.
    #[inline]
    pub fn zero() -> Self {
        Self { x: 0.0, y: 0.0 }
    }

    /// Shorthand for `Vector2::<f64>::new(1.0, 1.0)`.
    #[inline]
    pub fn one() -> Self {
        Self { x: 1.0, y: 1.0 }
    }

    /// Shorthand for `Vector2::<f64>::new(-1.0, 0.0)`.
    #[inline]
    pub fn left() -> Self {
        Self { x: -1.0, y: 0.0 }
    }
    /// Shorthand for `Vector2::<f64>::new(1.0, 0.0)`.
    #[inline]
    pub fn right() -> Self {
        Self { x: 1.0, y: 0.0 }
    }

    /// Shorthand for `Vector2::<f64>::new(0.0, -1.0)`.
    #[inline]
    pub fn down() -> Self {
        Self { x: 0.0, y: -1.0 }
    }

    /// Shorthand for `Vector2::<f64>::new(0.0, 1.0)`.
    #[inline]
    pub fn up() -> Self {
        Self { x: 0.0, y: 1.0 }
    }
}

// Vector2<T> == Vector2<T>, Vector2<T> != Vector2<T>
impl<T: Copy + PartialEq> PartialEq for Vector2<T> {
    #[inline]
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y
    }

    #[inline]
    fn ne(&self, other: &Self) -> bool {
        self.x != other.x || self.y != other.y
    }
}

impl<T: Copy + PartialEq> Eq for Vector2<T> {}

// Vector2<T> + Vector2<T>
impl<T: Copy + Add<Output = T>> Add for Vector2<T> {
    type Output = Self;

    #[inline]
    fn add(self, other: Self) -> Self {
        Self {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

// Vector2<T> += Vector2<T>
impl<T: Copy + AddAssign> AddAssign for Vector2<T> {
    #[inline]
    fn add_assign(&mut self, other: Self) {
        self.x += other.x;
        self.y += other.y;
    }
}

// Vector2<T> + T
impl<T: Copy + Add<Output = T>> Add<T> for Vector2<T> {
    type Output = Self;

    #[inline]
    fn add(self, other: T) -> Self {
        let other = other.into();
        Self {
            x: self.x + other,
            y: self.y + other,
        }
    }
}

// Vector2 += T
impl<T: Copy + AddAssign> AddAssign<T> for Vector2<T> {
    #[inline]
    fn add_assign(&mut self, other: T) {
        self.x += other;
        self.y += other;
    }
}

// Vector2<T> - Vector2<T>
impl<T: Copy + Sub<Output = T>> Sub for Vector2<T> {
    type Output = Self;

    #[inline]
    fn sub(self, other: Self) -> Self {
        Self {
            x: self.x - other.x,
            y: self.y - other.y,
        }
    }
}

// Vector2<T> -= Vector2<T>
impl<T: Copy + SubAssign> SubAssign for Vector2<T> {
    #[inline]
    fn sub_assign(&mut self, other: Self) {
        self.x -= other.x;
        self.y -= other.y;
    }
}

// Vector2<T> - T
impl<T: Copy + Sub<Output = T>> Sub<T> for Vector2<T> {
    type Output = Self;

    #[inline]
    fn sub(self, other: T) -> Self {
        Self {
            x: self.x - other,
            y: self.y - other,
        }
    }
}

// Vector2<T> -= T
impl<T: Copy + SubAssign> SubAssign<T> for Vector2<T> {
    #[inline]
    fn sub_assign(&mut self, other: T) {
        self.x -= other;
        self.y -= other;
    }
}

// Vector2<T> * Vector2<T>
impl<T: Copy + Mul<Output = T>> Mul for Vector2<T> {
    type Output = Self;

    #[inline]
    fn mul(self, other: Self) -> Self {
        Self {
            x: self.x * other.x,
            y: self.y * other.y,
        }
    }
}

// Vector2<T> *= Vector2<T>
impl<T: Copy + MulAssign> MulAssign for Vector2<T> {
    #[inline]
    fn mul_assign(&mut self, other: Self) {
        self.x *= other.x;
        self.y *= other.y;
    }
}

// Vector2<T> * T
impl<T: Copy + Mul<Output = T>> Mul<T> for Vector2<T> {
    type Output = Self;

    #[inline]
    fn mul(self, other: T) -> Self {
        Self {
            x: self.x * other,
            y: self.y * other,
        }
    }
}

// Vector2<T> *= T
impl<T: Copy + MulAssign> MulAssign<T> for Vector2<T> {
    #[inline]
    fn mul_assign(&mut self, other: T) {
        self.x *= other;
        self.y *= other;
    }
}

// Vector2<T> / Vector2<T>
impl<T: Copy + Div<Output = T>> Div for Vector2<T> {
    type Output = Self;

    #[inline]
    fn div(self, other: Self) -> Self {
        Self {
            x: self.x / other.x,
            y: self.y / other.y,
        }
    }
}

// Vector2<T> /= Vector2<T>
impl<T: Copy + DivAssign> DivAssign for Vector2<T> {
    #[inline]
    fn div_assign(&mut self, other: Self) {
        self.x /= other.x;
        self.y /= other.y;
    }
}

// Vector2<T> / T
impl<T: Copy + Div<Output = T>> Div<T> for Vector2<T> {
    type Output = Self;

    #[inline]
    fn div(self, other: T) -> Self {
        Self {
            x: self.x / other,
            y: self.y / other,
        }
    }
}

// Vector2<T> /= T
impl<T: Copy + DivAssign> DivAssign<T> for Vector2<T> {
    #[inline]
    fn div_assign(&mut self, other: T) {
        let other = other.into();
        self.x /= other;
        self.y /= other;
    }
}

// Vector2<T> % Vector2<T>
impl<T: Copy + Rem<Output = T>> Rem for Vector2<T> {
    type Output = Self;

    #[inline]
    fn rem(self, other: Self) -> Self {
        Self {
            x: self.x % other.x,
            y: self.y % other.y,
        }
    }
}

// Vector2<T> %= Vector2<T>
impl<T: Copy + RemAssign> RemAssign for Vector2<T> {
    #[inline]
    fn rem_assign(&mut self, other: Self) {
        self.x %= other.x;
        self.y %= other.y;
    }
}

// Vector2<T> % T
impl<T: Copy + Rem<Output = T>> Rem<T> for Vector2<T> {
    type Output = Self;

    #[inline]
    fn rem(self, other: T) -> Self {
        Self {
            x: self.x % other,
            y: self.y % other,
        }
    }
}

// Vector2<T> %= T
impl<T: Copy + RemAssign> RemAssign<T> for Vector2<T> {
    #[inline]
    fn rem_assign(&mut self, other: T) {
        self.x %= other;
        self.y %= other;
    }
}

// -Vector2<T>
impl<T: Copy + Neg<Output = T>> Neg for Vector2<T> {
    type Output = Self;

    #[inline]
    fn neg(self) -> Self {
        Self {
            x: -self.x,
            y: -self.y,
        }
    }
}
