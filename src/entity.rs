/// `Entity` that you can attach components to
pub struct Entity(usize, Vec<Box<dyn Component>>);

use std::sync::atomic::{AtomicUsize, Ordering};
static NEXT_ID: AtomicUsize = AtomicUsize::new(0);

impl Entity {
    /// Creates a new Entity
    pub fn new() -> Self {
        Self(NEXT_ID.fetch_add(1, Ordering::Relaxed), Vec::new())
    }

    /// Attaches a `Component` of type `T` to this entity
    pub fn attach<T: Component + 'static>(&mut self, component: T) -> &mut Self {
        self.1.push(Box::new(component));
        self
    }

    /// Returns a unique `id` of the Entity
    #[inline]
    pub fn id(&self) -> usize {
        self.0
    }
}

pub trait Component {}

pub trait Behavior: Component {
    fn update(&self);
}
